{ config, pkgs, nixpkgs, lib, ... }:
with lib;
let
  enable = config.yusef.gui.enable;
  custom-fonts = ((import ../packages/fonts) { inherit pkgs; inherit lib; });
in
{
  config = mkIf (enable) {
    fonts.fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ]; })
      fira-code
      noto-fonts
      powerline-fonts
      helvetica-neue-lt-std
      liberation_ttf
      custom-fonts.material-icons
      custom-fonts.feather-icons
    ];
  };
}