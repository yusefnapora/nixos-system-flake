{ config, pkgs, nixpkgs, lib, ... }:

{

  imports = [
    ./programs/git.nix
    ./programs/non-free.nix
  ];

  programs = {
    home-manager.enable = true;

    fish.enable = true;  



    vscode = { 
      enable = true;
    };
  };

  home = {
    stateVersion = "21.11";
    packages = with pkgs; [
      dmenu
      nixFlakes
      vscode
      jq
    ];
  };
}
