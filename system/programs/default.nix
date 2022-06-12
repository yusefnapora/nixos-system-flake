{ config, pkgs, lib, ... }:
with lib;
let
  packages = with pkgs; [
      vim 
      wget
      fish
      git
      tmux
      jq
  ];

  guiPackages = with pkgs; [
      firefox
  ];

  guiEnabled = config.yusef.gui.enable;
in
{
    imports = [
        ./sway.nix
        ./droidcam.nix
        ./docker.nix
    ];


    options.yusef.gui.enable = mkEnableOption "Enables GUI programs";

    config = { 

      # allow unfree (vscode, etc)
      nixpkgs.config.allowUnfree = true;

      # enable nix flakes
      nix.package = pkgs.nixUnstable;
      nix.extraOptions = ''
      experimental-features = nix-command flakes
      '';


      environment.systemPackages = packages ++ 
        lists.optionals guiEnabled guiPackages;

    };
}