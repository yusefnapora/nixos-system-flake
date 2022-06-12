# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/aarch64-utm.nix

      ../default.nix
    ];

  # custom options
  yusef = {
    gui.enable = true;
    sound.enable = true;
    sway.enable = true;
    home-manager.enable = true;
    docker.enable = true;
  };

  # enable auto-resize of guest display when vm window resizes
  services.spice-vdagentd.enable = true;

  # HiDPI settings for macbook pro 14"
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <${pkgs.writeText "Xresources" ''
      Xft.dpi: 250
      Xcursor.theme: Adwaita
      Xcursor.size: 64
      Xcursor.theme_core: 1
    ''}
  '';


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.enp0s6.useDHCP = true;
}

