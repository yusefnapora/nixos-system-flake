{ config, pkgs, lib, nur, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf types;
  inherit (lib.lists) optionals;

  packages = builtins.attrValues {
    inherit (pkgs)
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
    ;
  };

  guiPackages = builtins.attrValues {
    inherit (pkgs) firefox;
  };

  guiEnabled = config.yusef.gui.enable;
in
{
    imports = [
        ./i3.nix
        ./sway.nix
        ./droidcam.nix
        ./docker.nix
        ./obs.nix
        ./v4l2loopback.nix
        ./streamdeck
        ./kindle.nix
    ];


    config = { 

      nixpkgs = {
        overlays = [
          nur.overlay
          # add our custom packages as an overlay
          (import ../packages/overlay.nix)
        ];

        # allow unfree (vscode, etc)
        config.allowUnfree = true;
      };

      # enable nix flakes
      nix.package = pkgs.nixUnstable;
      nix.extraOptions = ''
      experimental-features = nix-command flakes repl-flake
      '';

      programs.fish.enable = true;

      # enable nix-ld to run unpatched binaries
      programs.nix-ld.enable = true;

      environment.systemPackages = packages ++ 
        optionals guiEnabled guiPackages;

    };
}
