{ lib, pkgs, config, nixosConfig, ... }:
with lib;
let
  inherit (nixosConfig.yusef.i3) enable dpi-scale;

  scaled = size: (lib.strings.floatToString (size * dpi-scale));
in
{
  config = mkIf enable {
    programs.rofi = {
      enable = true;

      terminal = "${pkgs.kitty}/bin/kitty";

      theme = (import ./theme.nix { inherit scaled; inherit config; }); 

      extraConfig = {
        modi = "drun,run,ssh,combi";
      };
    };
  };
}