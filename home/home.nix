{ config, pkgs, nixpkgs, lib, ... }:
{
  imports = [
    ../programs/git.nix
    ../programs/non-free.nix

    # ./i3.nix
    ./sway.nix
    ./fish.nix
  ];

  programs = {
    home-manager.enable = true;
    vscode = { 
      enable = true;
    };

    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  };

  home = {
    stateVersion = "21.11";
    packages = with pkgs; [
      kitty
      dmenu
      nixFlakes
      vscode
      jq
    ];
  };
}