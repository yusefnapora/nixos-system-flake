{ lib, nixosConfig, pkgs, ... }:
let
  inherit (lib) mkIf;

  cfg = nixosConfig.yusef.obs;
in
{
  config = mkIf cfg.enable {

    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-websocket
      ];
    };    

    home.packages = with pkgs; [
      # also install shotcut video editor for simple edits
      shotcut

      # and the obs-cli utility so we can script things
      yusef.obs-cli
    ];

  };
}