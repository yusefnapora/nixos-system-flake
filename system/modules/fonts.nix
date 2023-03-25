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
  # enableDefaultFonts = false;

  fonts.fontconfig = {
    enable = lib.mkForce true;

    defaultFonts = {
      serif = [ "Liberation Serif" "Joypixels" ];
      sansSerif = [ "SF Pro Display" "Joypixels" ];
      monospace = [ "FiraCode Nerd Font Mono" ];
      emoji = [ "Joypixels" ];
    };

    # fix pixelation
    antialias = true;

    # fix antialiasing blur
    hinting = {
      enable = true;
      style = "hintfull";
      autohint = true;
    };

    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };
  };

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
      iosevka
      joypixels
      ;

      # custom fonts from this repo (see system/packages/overlay.nix)
      inherit (pkgs.yusef.fonts) material-icons feather-icons sf-pro;
  };
}
