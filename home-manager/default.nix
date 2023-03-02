{ config, system, pkgs, nixpkgs, lib, nixosConfig ? {}, darwinConfig ? {}, inputs, ... }:
let
  inherit (inputs) nix-colors;
in {
  imports = [
    nix-colors.homeManagerModule

    ./system-config.nix
    ./programs
    ./desktop
  ];

  programs = {
    home-manager.enable = true;
  };

  colorScheme = nix-colors.colorSchemes.gruvbox-dark-soft;

  home = {
    stateVersion = "21.11";
    sessionVariables = {
      EDITOR = "hx";
      COLORTERM = "truecolor";
    };
  };
}
