{ lib, nixosConfig, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs.stdenv) isAarch64 isLinux;

  mkAsahiWrapper = (import ./asahi-wrapper.nix { inherit lib pkgs; });
  obs-package = mkAsahiWrapper { name = "obs"; package = pkgs.obs-studio; };
in {
  config = mkIf (isLinux && nixosConfig.yusef.obs.enable) {

    programs.obs-studio = {
      enable = true;
      package = obs-package;
    }; 

    home.packages = [
      # also install shotcut video editor for simple edits
      pkgs.shotcut

      # and the obs-cli utility so we can script things
      pkgs.yusef.obs-cli
    ];

  };
}
