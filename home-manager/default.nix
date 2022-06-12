{ config, pkgs, nixpkgs, lib, homeManagerFlags, ... }:
with lib;
let
  inherit (homeManagerFlags) withGUI withSway system;

  packages = with pkgs; [
    nixFlakes
    jq
    # _1password
  ];

  guiPackages = with pkgs; [
    kitty
    alacritty
    dmenu
    vscode
  ] ++ lists.optionals (system == "x86_64-linux") [
    # TODO: figure out how to install ARM beta
    _1password-gui
  ];
in
{
  imports = [
    ./git.nix
    ./sway.nix
    ./fish.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "1password"
      "1password-cli"
      "vscode"
      "vscode-with-extensions"        
  ];

  programs = {
    home-manager.enable = true;
    vscode = { 
      enable = withGUI;
    };

    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };

  home = {
    stateVersion = "21.11";
    packages = packages ++ lists.optionals (withGUI) guiPackages;
  };
}
