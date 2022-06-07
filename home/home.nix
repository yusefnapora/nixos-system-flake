{ config, pkgs, nixpkgs, lib, ... }:
{
  imports = [
    ../programs/git.nix
    ../programs/non-free.nix

    ./i3.nix
    ./fish.nix
  ];

  programs = {
    home-manager.enable = true;
    vscode = { 
      enable = true;
    };
  };

  home = {
    stateVersion = "21.11";
    packages = with pkgs; [
      kitty
      dmenu
      nixFlakes
      vscode
      jq
      wineApps.ade
    ];
  };
}
