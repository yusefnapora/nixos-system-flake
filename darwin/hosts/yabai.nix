{ config, pkgs, lib, ...}:
let
  inherit (lib) mkOption mkEnableOption types lists strings;
  cfg = config.yusef.yabai;

  floating-rules = lists.forEach cfg.floating-apps (name: 
    "yabai -m rule --add app='${name}' manage=off"
    );
  floating-rules-str = strings.concatStringsSep "\n" floating-rules;

in
{
  options.yusef.yabai = {
    enable = mkEnableOption "Enable yabai window manager";
    scriptingAdditions = mkEnableOption "Enable yabai scripting additions (requires SIP disabled)";

    floating-apps = mkOption {
      type = types.listOf types.str;
      description = "Names of unmanaged / floating apps";
      default = [
        "System Settings"
        "Zoom"
        "zoom.us"
      ];
    };

    config = mkOption {
      type = types.attrs;
      description = "yabai config values. overrides defaults";
      default = {};
    };

  };

  config = lib.mkIf cfg.enable {
    services.yabai = {
      enable = true;
      enableScriptingAddition = cfg.scriptingAdditions;

      config = {
        window_placement = "second_child";
        window_topmost = "on";
        window_shadow = "float";
        mouse_modifier = "ctrl";

      } // cfg.config;

      extraConfig = floating-rules-str 
      + ''
        yabai -m config layout bsp
      ''
      + strings.optionalString cfg.scriptingAdditions ''
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        sudo yabai --load-sa
      '';
    };

    environment.etc = lib.mkIf cfg.scriptingAdditions {
      "sudoers.d/10-yabai".text = ''
        %admin ALL=(root) NOPASSWD: ${pkgs.yabai}/bin/yabai --load-sa
      '';
    };

    services.skhd = let 
      hyper = "cmd + ctrl + alt";
      yabai = "${pkgs.yabai}/bin/yabai";
      wezterm = "/Applications/WezTerm.app/Contents/MacOS/wezterm";
    in {
      enable = true;

      skhdConfig = ''
        # sleep when "F13" key is pressed (mapped to scroll lock via karabiner)
        f13 : pmset displaysleepnow


        ${hyper} - return : ${wezterm} start
        ${hyper} - h : ${yabai} -m window --swap west  
        ${hyper} - j : ${yabai} -m window --swap south  
        ${hyper} - k : ${yabai} -m window --swap north 
        ${hyper} - l : ${yabai} -m window --swap east

        ${hyper} - space : ${yabai} -m window --toggle float
        ${hyper} - b : ${yabai} -m space --balance

        # increase size of the left-child (decrease size of right-child) of the containing node
        ${hyper} + shift - l : ${yabai} -m window --ratio rel:0.1

        # increase size of the right-child (decrease size of left-child) of the containing node
        ${hyper} + shift - h : ${yabai} -m window --ratio rel:-0.1
      ''
      + strings.optionalString cfg.scriptingAdditions ''
        ${hyper} - left : ${yabai} -m window --space prev
        ${hyper} - right : ${yabai} -m window --space next
        ${hyper} - up : ${yabai} -m window --display recent
      '';
    };

    environment.systemPackages = [ pkgs.skhd ];
  };


}
