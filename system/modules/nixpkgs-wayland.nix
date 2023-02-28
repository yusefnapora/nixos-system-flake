{ config, lib, nixpkgs-wayland, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.yusef.nixpkgs-wayland;
in {
  options.yusef.nixpkgs-wayland = {
    enable = mkEnableOption "Enable nixpkgs-wayland overlay";
  };

  config = mkIf cfg.enable {
    # add binary caches
    nix.settings = {
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
    };

    # add nixpkgs overlay
    nixpkgs.overlays = [ nixpkgs-wayland.overlay ];
  };
}
