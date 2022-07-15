{ nixosConfig, pkgs, lib, ... }:
with lib;
let
  enable = nixosConfig.yusef.gui.enable;
in
{
  programs.kitty = mkIf enable {
    enable = true;
    settings = {
      background_opacity = "0.8";
    };
  };
}