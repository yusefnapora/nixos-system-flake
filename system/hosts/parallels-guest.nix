# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/parallels

      ../default.nix
    ];

  # custom options
  yusef = {
    system = "aarch64-linux";
    _1password.enable = true;
    gui.enable = true;
    sound.enable = true;
    # sway = { 
    #   enable = true;
    #   no-hardware-cursors-fix = true;
    #   startup-commands = [
    #     { command = "swaymsg -- output Virtual-1 scale 2 mode --custom 3600x2252@120Hz"; always = true; }
    #   ];
    # };
    i3 = { 
      enable = true;
      dpi-scale = 2.0;
      gaps = {};
      startup = [
        { command = "xrandr --output Virtual-1 --mode 3600x2252 --dpi 250"; }
      ];
    };
    docker.enable = true;
    trilium.enable = true;
  };

  # HiDPI settings for macbook pro 14"
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <${pkgs.writeText "Xresources" ''
      Xft.dpi: 250
      Xcursor.theme: Adwaita
      Xcursor.size: 64
      Xcursor.theme_core: 1
    ''}
  '';
  services.xserver = {
    monitorSection = ''
      Modeline "3600x2252"  696.00  3600 3896 4288 4976  2252 2255 2265 2332 -hsync +vsync
    '';

    deviceSection = ''
      Option "ModeValidation" "AllowNonEdidModes"
    '';
  };

  networking.hostName = "parallels"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.enp0s5.useDHCP = true;
}

