# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/nuc11.nix

      ../default.nix
    ];

  # custom options
  yusef = {
    gui.enable = true;
    _1password.enable = true;
    sound.enable = true;
    bluetooth.enable = true;
    i3.enable = true;
    # sway = { 
    #   enable = true; 
    #   natural-scrolling = true;
    # };
    key-remap = { 
      enable = true; 
      caps-to-ctrl-esc= true; 
      swap-left-alt-and-super= true; 
    };
    docker.enable = true;
    droidcam.enable = true;
    kvm-switch.enable = true;
    obs.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nux"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.enp88s0.useDHCP = true;

}

