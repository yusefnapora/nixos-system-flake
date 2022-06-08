# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      ../common.nix

      # remap capslock to ctrl/esc
      ../../modules/key-remap.nix
    ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "fusion"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.ens33.useDHCP = true;

  virtualisation.vmware.guest.enable = true;


  # enable the v4l2loopback module, for droidcam, etc
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback.out
  ];

  boot.kernelModules = [
    "v4l2loopback"
    "snd-aloop"
  ];

  boot.extraModprobeConfig = ''
  options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';
}

