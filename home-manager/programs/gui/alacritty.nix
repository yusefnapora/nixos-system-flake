{ lib, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "FiraCode Nerd Font Mono";
      font.bold.family = "FiraCode Nerd Font Mono";
    };
  };
}
