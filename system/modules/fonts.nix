{ config, pkgs, nixpkgs, lib, ... }:
with lib;
let
  enable = config.yusef.gui.enable;
  custom-fonts = ((import ../packages/fonts) { inherit pkgs; inherit lib; });
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
      custom-fonts.material-icons
      custom-fonts.feather-icons
    ];
  };
}