{ config, pkgs, lib, system, nixosConfig ? {}, darwinConfig ? {}, ... }:
let
  inherit (lib.lists) optionals;
  inherit (lib.attrsets) optionalAttrs;

  systemConfig = nixosConfig // darwinConfig;
  cfg = systemConfig.yusef.fish;
  isLinux = lib.strings.hasSuffix "linux" system;
in
{

  home.packages = builtins.attrValues {
    inherit (pkgs)
      exa
      starship
      any-nix-shell
      ;
  };

  programs.fish = {
      enable = true;

      shellAliases = {
          ls = "${pkgs.exa}/bin/exa";
          nix-search = "nix-env -qaP";
      };

      functions = {
        # get the current nix store path for the given binary
        nix-which = "readlink -e (which $argv[1])";

        # like nix-which, but stripping out the /bin/$program_name bit
        # useful for checking out other files in the same package
        nix-which-dir = "nix-which $argv[1] | sed -e 's/\\/bin\\/.*$//'";
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