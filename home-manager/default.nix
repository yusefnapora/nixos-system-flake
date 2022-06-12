{ config, pkgs, nixpkgs, lib, homeManagerFlags, ... }:
with lib;
let
  inherit (homeManagerFlags) withGUI withSway;

  packages = with pkgs; [
    nixFlakes
    jq
    _1password
  ];

  guiPackages = with pkgs; [
    kitty
    alacritty
    dmenu
    vscode
    # _1password-gui # TODO: skip on aarch64 (or figure out how to install beta)
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
