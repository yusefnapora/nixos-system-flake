{ config, pkgs, ... }:
{

  # Enable the X11 windowing system.
  services.xserver = { 
    enable = true;
    displayManager.defaultSession = "xfce+i3";
    desktopManager = { 
      xterm.enable = false;
      xfce = { 
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
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