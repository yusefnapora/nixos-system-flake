# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:
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
    i3 = { 
      enable = true;
      dpi-scale = 2.0;
      gaps = {};
    };
    docker.enable = true;
    trilium.enable = true;
  };

  # HiDPI settings for macbook pro 14"
  services.xserver = {
    displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <${pkgs.writeText "Xresources" ''
      Xft.dpi: 220
      Xcursor.theme: Adwaita
      Xcursor.size: 48
      Xcursor.theme_core: 1
    ''}
  '';
    
    dpi = 220;
    resolutions = lib.mkOverride 5 [
      { x = 3600; y = 2252; }
    ];

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

