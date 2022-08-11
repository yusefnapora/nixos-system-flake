{ config, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf types;
  inherit (lib.lists) optionals;

  packages = with pkgs; [
      vim 
      wget
      fish
      git
      tmux
      jq
      sqlite
      htop
      killall
      tree
  ];

  guiPackages = with pkgs; [
      firefox
  ];

  guiEnabled = config.yusef.gui.enable;
in
{
    imports = [
        ./sway.nix
        ./i3.nix
        ./droidcam.nix
        ./docker.nix
        ./1password.nix
        ./obs.nix
        ./v4l2loopback.nix
        ./streamdeck
        ./trilium.nix
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

      nixpkgs = {
        # add our custom packages as an overlay
        overlays = [
            (import ../packages/overlay.nix)
        ];

        # allow unfree (vscode, etc)
        config.allowUnfree = true;
      };

      # enable nix flakes
      nix.package = pkgs.nixUnstable;
      nix.extraOptions = ''
      experimental-features = nix-command flakes
      '';

      programs.fish.enable = true;

      environment.systemPackages = packages ++ 
        optionals guiEnabled guiPackages;

    };
}
