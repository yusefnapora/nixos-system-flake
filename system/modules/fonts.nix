{ config, pkgs, nixpkgs, lib, ... }:
with lib;
let
  enable = config.yusef.gui.enable;
in
{
  config = mkIf (enable) {
    fonts.fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      fira-code
      noto-fonts
      powerline-fonts
      helvetica-neue-lt-std
      liberation_ttf
    ];
  };
}