{ config, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption types;
   
  cfg = config.yusef.i3;
in
{
  options.yusef.i3 = {
    enable = mkEnableOption "Use i3 as X11 window manager";

    terminal = mkOption {
      type = types.str;
      description = "default terminal emulator";
      default = "kitty";
    };

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

    natural-scrolling = mkOption {
      type = types.bool;
      description = "enable libinput natural scrolling (mouse and touchpad)";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;

      libinput = {
        enable = true;
        mouse.naturalScrolling = cfg.natural-scrolling;
        touchpad.naturalScrolling = cfg.natural-scrolling;
      };

      desktopManager = { 
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };

      displayManager = { 
        defaultSession = "xfce+i3";
      };

      windowManager.i3 = { 
        enable = true;
      };
    };

    # enable gnome-keyring, so 1password, etc can use it
    services.gnome = {
      gnome-keyring.enable = true;
    };

    programs.dconf.enable = true;
    security.pam.services.xdm.enableGnomeKeyring = true;

    # enable browsing smb shares in thunar, etc
    # see: https://nixos.wiki/wiki/Samba#Browsing_samba_shares_with_GVFS
    services.gvfs.enable = true;    
  };
}
