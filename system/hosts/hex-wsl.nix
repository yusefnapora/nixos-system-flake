{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  # TODO: use as flake input instead of putting nixos-wsl in this repo
  nixos-wsl = import ./hardware/nixos-wsl;
in
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"

    nixos-wsl.nixosModules.wsl

    ../default.nix
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "yusef";
    startMenuLaunchers = true;

    # Enable native Docker support
    docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };

  yusef = {
    gui.enable = true;
  };

  networking.hostName = "Hex";

  system.stateVersion = lib.mkForce "22.05";
}
