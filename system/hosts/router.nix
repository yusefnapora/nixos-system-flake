{ lib, config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/router.nix

      ../default.nix
    ];

  # custom options
  yusef = {
    fonts.enable = false;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "router"; # Define your hostname.
  system.stateVersion = "23.05";
}

