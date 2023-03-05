{ lib, pkgs, config, ... }:
let
  inherit (config.colorScheme) colors;
in {
  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "FiraCode Nerd Font Mono";
      font.bold.family = "FiraCode Nerd Font Mono";

      colors.primary = {
        foreground = "#${colors.base05}";
        background = "#${colors.base00}";
      };
    };
  };
}
