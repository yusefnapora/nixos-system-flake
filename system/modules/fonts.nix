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

  console-font = if config.yusef.hidpi then "ter-powerline-v32n.psf.gz" else "ter-powerline-v16.psf.gz";
in
{
  options.yusef.hidpi = lib.mkEnableOption "Enable hi-dpi console fonts";

  config = {

    # set the console font
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      earlySetup = true;
      font = "${pkgs.powerline-fonts}/share/consolefonts/${console-font}";
      packages = [ pkgs.powerline-fonts ];
      keyMap = "us";
    };

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
  };
}
