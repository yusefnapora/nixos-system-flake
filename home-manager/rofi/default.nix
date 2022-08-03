{ lib, pkgs, config, nixosConfig, ... }:
let
  inherit (lib) mkIf;
  inherit (nixosConfig.yusef.i3) enable dpi-scale;

  scaled = size: (lib.strings.floatToString (size * dpi-scale));
in
{
  config = mkIf enable {
    programs.rofi = {
      enable = true;

      plugins = with pkgs; [ rofi-emoji rofi-calc ];

      terminal = "${pkgs.kitty}/bin/kitty";

      theme = (import ./theme.nix { inherit scaled; inherit config; }); 

      extraConfig = {
        modi = "drun,run,emoji,calc,ssh,combi";
      };
    };
  };
}