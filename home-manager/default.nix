{ config, system, pkgs, nixpkgs, lib, nixosConfig ? {}, darwinConfig ? {}, inputs, ... }:
let
  inherit (inputs) nix-colors;
in {
  imports = [
    nix-colors.homeManagerModule

    ./system-config.nix
    ./programs
    ./desktop
  ];

  programs = {
    home-manager.enable = true;
  };

  colorScheme = nix-colors.colorSchemes.spaceduck;

  # write the color scheme to a CSS file for future reference
  home.file.".config/colorscheme.css".text = let 
    colors = config.colorScheme.colors;
  in ''
    /*
      color scheme: ${config.colorScheme.name} (${config.colorScheme.kind})
    */
    :root { 
      --color-base00: #${colors.base00};
      --color-base01: #${colors.base01};
      --color-base02: #${colors.base02};
      --color-base03: #${colors.base03};
      --color-base04: #${colors.base04};
      --color-base05: #${colors.base05};
      --color-base06: #${colors.base06};
      --color-base07: #${colors.base07};
      --color-base08: #${colors.base08};
      --color-base09: #${colors.base09};
      --color-base0A: #${colors.base0A};
      --color-base0B: #${colors.base0B};
      --color-base0C: #${colors.base0C};
      --color-base0D: #${colors.base0D};
      --color-base0E: #${colors.base0E};
      --color-base0F: #${colors.base0F};
    }
  '';

  home = {
    stateVersion = "21.11";
    sessionVariables = {
      EDITOR = "hx";
      COLORTERM = "truecolor";
    };
  };
}
