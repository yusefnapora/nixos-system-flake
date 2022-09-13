{ config, nixosConfig, pkgs, lib, ... }:
let
  inherit (lib.lists) optionals;
  inherit (lib.attrsets) optionalAttrs;

  withGUI = nixosConfig.yusef.gui.enable;
in
{

  home.packages = with pkgs; [
      exa
      starship
      any-nix-shell
  ] ++ optionals (withGUI) [
    xclip
  ];

  programs.fish = {
      enable = true;

      shellAliases = {
          ls = "exa";
          nix-search = "nix-env -qaP"; 
      } // optionalAttrs (withGUI) {
          pbcopy = "xclip -selection clipboard";
          pbpaste = "xclip -selection clipboard -o";
      };

      shellInit = ''
        # init starship prompt
        ${pkgs.starship}/bin/starship init fish | source

        set -x EDITOR vim
      '';

      interactiveShellInit = ''
        # setup any-nix-shell integration
        any-nix-shell fish --info-right | source
      '';

  };

  programs.broot = {
      enable = true;
      enableFishIntegration = true;
  };
}
