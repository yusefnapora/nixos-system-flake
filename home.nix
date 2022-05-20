{ config, pkgs, nixpkgs, lib, ... }:

{

  imports = [
    ./programs/non-free.nix
  ];

  programs = {
    home-manager.enable = true;

    fish.enable = true;
    fzf.enable = true;
    
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };

    git = { 
      enable = true;
      userName = "Yusef Napora";
      userEmail = "yusef@napora.org";
    };

    vscode = { 
      enable = true;
      extensions = with pkgs.vscode-extensions; [ 
        # yzhang.markdown-all-in-one
      ];
    };
  };

  home.stateVersion = "21.11";
  home.packages = with pkgs; [
    _1password
    dmenu
    nixFlakes
    vscode
    jq

  ];
}
