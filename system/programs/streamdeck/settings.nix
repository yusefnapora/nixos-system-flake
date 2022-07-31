{ pkgs, lib, config, ...}:
with lib;
let
  inherit (lib.attrsets) filterAttrs nameValuePair;
  inherit (lib.lists) range forEach;

  cfg = config.yusef.streamdeck;

  # options for a single stream deck button
  button-module = types.submodule {
    options = {
      button = mkOption {
        type = types.int;
        description = "button index for this button. range is 0 .. (num_buttons - 1)";
      };

      icon = mkOption {
        type = types.nullOr types.str;
        description = "path to image file";
        default = null; 
      };

      text = mkOption {
        type = types.nullOr types.str;
        description = "text label to display";
        default = null;
      };

      command = mkOption {
        type = types.nullOr types.str;
        description = "command to execute when button is pressed";
        default = null; 
      };

      keys = mkOption {
        type = types.nullOr types.str;
        description = "keypress to trigger (x11 only)";
        default = null;
      };

      switch-page = mkOption {
        type = types.nullOr types.int;
        description = "switch to streamdeck page";
        default = null;
      };

      brightness-change = mkOption {
        type = types.nullOr types.int;
        description = "+/- amount to adjust streamdeck brightness";
        default = null;
      };

      write = mkOption {
        type = types.nullOr types.str;
        description = "text to write (x11 only)";
        default = null;
      };
    };
  };

  page-module = types.submodule {
    options = {
      page = mkOption {
        type = types.int;
        description = "page number. range 0 .. 9";
        default = 0;
      };

      buttons = mkOption {
        type = types.listOf button-module;
        description = "buttons in this page";
        default = [];
      };
    };
  };

  device-config-module = types.submodule {
    options = {
      device-id = mkOption {
        type = types.str;
        description = "device serial id. default is mine cause I'm lazy";
        default = "DL51K1A63326";
      };

      num-buttons = mkOption {
        type = types.int;
        description = "number of buttons on your device";
        default = 15;
      };

      brightness = mkOption {
        type = types.nullOr types.int;
        description = "stream deck brightness";
        default = null;
      };
  
      brightness-dimmed = mkOption {
        type = types.nullOr types.int;
        description = "brightness when auto-dimmed";
        default = null;
      };

      display-timeout = mkOption {
        type = types.nullOr types.int;
        description = "seconds of inactivity before auto-dimming";
        default = null;
      };


      pages = mkOption {
        type = types.listOf page-module;
        description = "page definitions. docs TDB";
        default = [];
      };
    };
  };

  # returns an attr set with fields numbered 0 - (num-1),
  # whose values are empty attribute sets
  empty-objects = 
    num:
      (builtins.listToAttrs
        (forEach 
          (range 0 (num - 1))
          (i: (nameValuePair (toString i) {}))));

  # returns an attribute set defining a button's properties,
  # given a button-submodule nix expression
  button-definition = b: filterAttrs 
    (n: v: v != null) 
    {
      icon = b.icon;
      text = b.text;
      command = b.command;
      keys = b.keys;
      switch_page = b.switch-page;
      brightness_change = b.brightness-change;
      write = b.write;
    };
  
  button-defs = page-buttons: 
    (builtins.listToAttrs
      (forEach page-buttons
        (b: (nameValuePair (toString b.button) (button-definition b)))));

  full-page = num-buttons: page-buttons:
    (empty-objects num-buttons) // (button-defs page-buttons);

  blank-pages = num-buttons:
    (builtins.listToAttrs
      (forEach (range 0 10)
        (i: nameValuePair (toString i) (empty-objects num-buttons))));

  to-json = device-config: let 
    page-definitions = 
     (builtins.listToAttrs
      (forEach device-config.pages
        (p: nameValuePair 
          (toString p.page) 
          (full-page device-config.num-buttons p.buttons))));

    obj = {
      streamdeck_ui_version = 1;
      state = {
        "${device-config.device-id}" = (filterAttrs (n: v: v != null) {
          buttons = (blank-pages device-config.num-buttons) // page-definitions;
          brightness = device-config.brightness;
          brightness_dimmed = device-config.brightness-dimmed;
          display_timeout = device-config.display-timeout;
        });
      };
    };
  in (builtins.toJSON obj);


  default-config = (import ./my-config.nix { inherit lib; inherit pkgs; });
in
{
  options.yusef.streamdeck.settings = mkOption {
    type = types.nullOr device-config-module;
    description = "streamdeck-ui settings json file. will be linked to /etc/streamdeck_ui.json - you'll need to manually symlink to ~/.streamdeck_ui.json";
    default = default-config;
  };


  config = mkIf (cfg.enable && cfg.settings != null) {
    environment.etc."streamdeck_ui.json" = {
      source = pkgs.writeTextFile { 
        text = (to-json cfg.settings);
        name = "streamdeck_ui.json";
      };
    };
  };
}