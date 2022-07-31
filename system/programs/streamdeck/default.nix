{ config, lib, pkgs, ...}:
let
  inherit (lib) mkEnableOption mkOption mkIf;

  cfg = config.yusef.streamdeck;

  
in
{
  imports = [
    ./settings.nix
  ];

  options.yusef.streamdeck = {
    enable = mkEnableOption "Enable streamdeck-ui for Elgato stream deck";
  };

  config = mkIf cfg.enable {
    programs.streamdeck-ui.enable = true;
    
    yusef.i3.startup = [
      { command = "sleep 1 && ${pkgs.streamdeck-ui}/bin/streamdeck -n &"; }
    ];

    environment.systemPackages = [ pkgs.xdotool ];
  };
}