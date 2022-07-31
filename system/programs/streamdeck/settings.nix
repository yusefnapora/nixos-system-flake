{ pkgs, lib, config, ...}:
with lib;
let
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
        types = types.str;
        description = "device serial id. default is mine cause I'm lazy";
        default = "DL51K1A63326";
      };

      num-buttons = mkOption {
        types = types.int;
        descriptions = "number of buttons on your device";
        default = 15;
      }

      pages = mkOption {
        type = types.listOf page-module;
        description = "page definitions. docs TDB";
        default = [];
      };
    };
  };

  to-json = device-config: let 
    button-definition = b: {
      # todo: there's probably something clever for this...
      # i basically just want to convert null to undefined
      icon = lib.mkIf (b.icon != null) b.image;
      text = lib.mkIf (b.text != null) b.label;
      command = lib.mkIf (b.command != null) b.command;
      keys = lib.mkIf (b.keys != null) b.keys;
      switch_page = lib.mkIf (b.switch-page != null) b.switch-page;
      brightness_change = lib.mkIf (b.brightness-change != null) b.brightness-change;
      write = lib.mkIf (b.write != null) b.write;
    };

    page-definitions = (map (p: {
      "${p.page}": (map (b: {
        "${b.button}" = (button-definition b);
      })
      p.buttons) 
    }) 
    device-config.pages);

    obj = {
      streamdeck_ui_version = 1;
      state = {
        "${device-config.device-id}" = {
          buttons = page-definitions;
        };
      };
    };
  in (builtins.toJSON );
in
{
  options.yusef.streamdeck.settings = mkOption {
    type = types.nullOr device-config-module;
    description = "streamdeck-ui settings json file. will be linked to /etc/streamdeck-ui.json - you'll need to manually symlink to ~/.streamdeck_ui.json";
    default = null;
  };


  config = mkIf (cfg.enable && cfg.settings != null) {
    environment.etc."streamdeck-ui.json" = {
      text = (to-json cfg.settings);
    };
  };
}