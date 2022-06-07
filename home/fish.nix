{ config, pkgs, nixpkgs, lib, ... }:
{

  home.packages = with pkgs; [
      exa
  ];

  programs.fish = {
      enable = true;

      shellAliases = {
          ls = "exa";
          pbcopy = "xclip -selection clipboard";
          pbpaste = "xclip -selection clipboard -o";
      };
  };

  programs.broot = {
      enable = true;
      enableFishIntegration = true;
  };
}
