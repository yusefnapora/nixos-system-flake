# Oracle cloud free VM (aarch64)
{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware/aarch64-oracle.nix

    ../default.nix
  ];

  yusef = {
    docker.enable = true;
  };


  boot.loader.systemd-boot.enable = true;
  networking.hostName = "pythia";
  system.stateVersion = lib.mkForce "22.05";
}