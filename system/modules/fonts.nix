{ config, pkgs, lib, ... }:
with lib;
let
  enable = config.yusef.gui.enable;
  nerd-fonts = [
    "FiraCode"
    "DroidSansMono"
    "JetBrainsMono"
    "FantasqueSansMono"
    "Iosevka"
  ];
in
{
  config = mkIf (enable) {
    fonts.fontconfig.enable = true;
    fonts.fonts = with pkgs; [
      (nerdfonts.override { fonts = nerd-fonts; })
      fira-code
      noto-fonts
      open-fonts
      powerline-fonts
      helvetica-neue-lt-std
      liberation_ttf

      # custom fonts from this repo (see system/packages/overlay.nix)
      yusef.fonts.material-icons
      yusef.fonts.feather-icons
    ];
  };
}