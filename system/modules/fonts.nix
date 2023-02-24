{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  
  nerd-fonts = [
    "FiraCode"
    "DroidSansMono"
    "JetBrainsMono"
    "FantasqueSansMono"
    "Iosevka"
  ];
in
{
  fonts.fontconfig.enable = lib.mkForce true;
  fonts.fonts = [
    (pkgs.nerdfonts.override { fonts = nerd-fonts; })
  ] ++ builtins.attrValues {
    inherit (pkgs)
      fira-code
      noto-fonts
      open-fonts
      powerline-fonts
      helvetica-neue-lt-std
      liberation_ttf
      ;

      # custom fonts from this repo (see system/packages/overlay.nix)
      inherit (pkgs.yusef.fonts) material-icons feather-icons;
  };
}
