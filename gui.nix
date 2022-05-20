{ config, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver = { 
    enable = true;
    displayManager.defaultSession = "none+i3";
    desktopManager = { 
      xterm.enable = false;
    };
    windowManager.i3 = { 
      enable = true;
      extraPackages = with pkgs; [ 
        dmenu
        i3status
        i3lock
      ];
    };
  };

  # HiDPI settings for macbook pro 14"
  # TODO: move this to per-system config
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <${pkgs.writeText "Xresources" ''
      Xft.dpi: 250
      Xcursor.theme: Adwaita
      Xcursor.size: 64
      Xcursor.theme_core: 1
    ''}
  '';

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

}