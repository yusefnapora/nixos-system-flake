{ config, lib, pkgs, ...}:
{
  home.packages = with pkgs.jetbrains; [
    idea-ultimate
    clion
  ];
}