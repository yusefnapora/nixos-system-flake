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

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

}