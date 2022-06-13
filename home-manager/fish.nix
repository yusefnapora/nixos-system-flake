{ config, pkgs, lib, ... }:
{

  home.packages = with pkgs; [
      exa
      xclip
      starship
  ];

  programs.fish = {
      enable = true;

      shellAliases = {
          ls = "exa";
          pbcopy = "xclip -selection clipboard";
          pbpaste = "xclip -selection clipboard -o";
      };

      shellInit = ''
      # init starship prompt
      ${pkgs.starship}/bin/starship init fish | source
      '';

  };

  programs.broot = {
      enable = true;
      enableFishIntegration = true;
  };
}
