{ config, nixosConfig, pkgs, lib, ... }:
with lib;
let
  withGUI = nixosConfig.yusef.gui.enable;
in
{

  home.packages = with pkgs; [
      exa
      starship
  ] ++ lists.optionals (withGUI) [
    xclip
  ];

  programs.fish = {
      enable = true;

      shellAliases = {
          ls = "exa";
          nix-search = "nix-env -qaP"; 
      } // attrsets.optionalAttrs (withGUI) {
          pbcopy = "xclip -selection clipboard";
          pbpaste = "xclip -selection clipboard -o";
      };

      shellInit = ''
      # init starship prompt
      ${pkgs.starship}/bin/starship init fish | source

      set -x EDITOR vim
      '';

  };

  programs.broot = {
      enable = true;
      enableFishIntegration = true;
  };
}
