{ config, pkgs, nixpkgs, lib, ... }:
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
      docker-compose
      google-chrome-dev
      droidcam
      _1password-gui
      _1password
    ];
  };
}
