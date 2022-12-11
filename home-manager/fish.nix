{ config, pkgs, lib, system, nixosConfig ? {}, darwinConfig ? {}, ... }:
let
  inherit (lib.lists) optionals;
  inherit (lib.attrsets) optionalAttrs;

  systemConfig = nixosConfig // darwinConfig;
  cfg = systemConfig.yusef.fish;
  isLinux = lib.strings.hasSuffix "linux" system;

  linuxGUI = isLinux && systemConfig.yusef.gui.enable;
in
{

  home.packages = with pkgs; [
      exa
      starship
      any-nix-shell
  ] ++ optionals (linuxGUI) [
    xclip
  ];

  programs.fish = {
      enable = true;

      shellAliases = {
          ls = "${pkgs.exa}/bin/exa";
          nix-search = "nix-env -qaP"; 
      } // optionalAttrs (linuxGUI) {
          pbcopy = "xclip -selection clipboard";
          pbpaste = "xclip -selection clipboard -o";
      };

      shellInit = ''
        # init starship prompt
        ${pkgs.starship}/bin/starship init fish | source

        ${cfg.init}
      '';

      interactiveShellInit = ''
        # setup any-nix-shell integration
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      '';

      plugins = [
        {
          name = "fish-ssh-agent";
          src = pkgs.fetchFromGitHub {
            owner = "danhper";
            repo = "fish-ssh-agent";
            rev = "fd70a2afdd03caf9bf609746bf6b993b9e83be57";
            sha256 = "sha256-e94Sd1GSUAxwLVVo5yR6msq0jZLOn2m+JZJ6mvwQdLs=";
          };
        }
      ];
  };

  programs.broot = {
      enable = true;
      enableFishIntegration = true;
  };
}
