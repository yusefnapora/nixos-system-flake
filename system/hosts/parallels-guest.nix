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
    sway.enable = true;
    docker.enable = true;
  };

  networking.hostName = "parallels"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.enp0s5.useDHCP = true;
}
