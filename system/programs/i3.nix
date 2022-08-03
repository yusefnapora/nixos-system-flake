{ config, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
   
  cfg = config.yusef.i3;
in
{
  options.yusef.i3 = {
    enable = mkEnableOption "Use i3 as X11 window manager";

    startup = mkOption {
      type = types.listOf types.attrs;
      description = "startup commands for i3 config";
      default = [];
    };

    dpi-scale = mkOption {
      type = types.float;
      description = "dpi scale factor (affects polybar fonts, etc)";
      default = 1.0;
    };

    gaps = mkOption {
      type = types.attrs;
      description = "i3 gaps settings";
      default = {
        inner = 10;
        outer = 5;
      };
    };
  };

  config = mkIf cfg.enable {
     services.xserver = {
      enable = true;

      libinput = {
        enable = true;
      };

      desktopManager = { 
        xterm.enable = false;
      };

      displayManager = { 
        defaultSession = "none+i3";
      };

      windowManager.i3 = { 
        enable = true;
      };
     }; 
  };
}
