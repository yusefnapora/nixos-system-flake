{ config, pkgs, lib, nur, nixpkgs, ... }:
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
        ./podman.nix
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
        # accept joypixels emoji font license
        config.joypixels.acceptLicense = true;


      };

      # enable nix flakes
      nix.package = pkgs.nixUnstable;
      nix.extraOptions = ''
      experimental-features = nix-command flakes repl-flake
      '';

      # set the flake registry entry for nixpkgs to current revision
      # used to build the config
      nix.registry = {
        nixpkgs.flake = nixpkgs;
      };


      programs.fish.enable = true;

      # enable nix-ld to run unpatched binaries
      programs.nix-ld.enable = true;

      environment.systemPackages = packages ++ 
        optionals guiEnabled guiPackages;

    };
}
