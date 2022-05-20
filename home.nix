{ config, pkgs, nixpkgs, lib, ... }:

{

  imports = [
    ./programs/non-free.nix
  ];

  programs = {
    home-manager.enable = true;

    fish.enable = true;  

    git = { 
      enable = true;
      userName = "Yusef Napora";
      userEmail = "yusef@napora.org";
    };

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
