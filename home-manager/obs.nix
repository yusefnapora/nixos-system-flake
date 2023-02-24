{ lib, nixosConfig, pkgs, ... }:
let
  inherit (lib) mkIf;

  cfg = nixosConfig.yusef.obs;
in
{
  config = mkIf cfg.enable {

    programs.obs-studio = {
      enable = true;
    };    

    home.packages = [
      # also install shotcut video editor for simple edits
      pkgs.shotcut

      # and the obs-cli utility so we can script things
      pkgs.yusef.obs-cli
    ];

  };
}
