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
      sqlite
      htop
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
        ./1password.nix
    ];

    options.yusef = {
        gui.enable = mkEnableOption "Enables GUI programs";

        system = mkOption {
            type = types.str;
            description = "nix system, e.g. x86_64-linux, aarch64-linux, etc";
            default = "x86_64-linux";
        };
    };


    config = { 

      # allow unfree (vscode, etc)
      nixpkgs.config.allowUnfree = true;

      # enable nix flakes
      nix.package = pkgs.nixUnstable;
      nix.extraOptions = ''
      experimental-features = nix-command flakes
      '';

      programs.fish.enable = true;

      environment.systemPackages = packages ++ 
        lists.optionals guiEnabled guiPackages;

    };
}
