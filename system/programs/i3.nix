{ config, pkgs, lib, ... }:
with lib;
let 
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
  };

  config = mkIf cfg.enable {
     services.xserver = {
      enable = true;
      
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
