# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/vmware-guest.nix

      ../default.nix
    ];

  # custom options
  yusef = {
    gui.enable = true;
    sound.enable = true;
    i3 = { 
      enable = true; 
    };
    key-remap = { 
      enable = true; 
      caps-to-ctrl-esc = true; 
    };
    docker.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "virtualboy"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.ens33.useDHCP = true;

  virtualisation.vmware.guest.enable = true;

}

