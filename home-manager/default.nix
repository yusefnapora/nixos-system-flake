{ config, system, pkgs, nixpkgs, lib, nixosConfig ? {}, darwinConfig ? {}, ... }:
{
  imports = [
    ./system-config.nix
    ./programs
    ./desktop
  ];

  programs = {
    home-manager.enable = true;
  };


  home = {
    stateVersion = "21.11";
    sessionVariables = {
      EDITOR = "hx";
      COLORTERM = "truecolor";
    };
  };
}
