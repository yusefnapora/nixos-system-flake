{ config, lib, pkgs, ...}:
let
  inherit (lib) mkEnableOption mkOption mkIf;

  cfg = config.yusef.streamdeck;

  startup-script = (pkgs.writeScriptBin "start-streamdeck" ''
  #!/usr/bin/env bash
  # TODO: without the sleep, the systray icon doesn't show in polybar... why tho?
  sleep 1
  cp /etc/streamdeck_ui.json $HOME/.streamdeck_ui.json
  streamdeck -n & 
  '');
in
{
  imports = [
    ./settings.nix
  ];

  options.yusef.streamdeck = {
    enable = mkEnableOption "Enable streamdeck-ui for Elgato stream deck";
  };

  config = mkIf cfg.enable {
    # programs.streamdeck-ui.enable = true;
    
    yusef.i3.startup = [
      { command = "${startup-script}/bin/start-streamdeck"; }
    ];

    environment.systemPackages = [ pkgs.unstable.streamdeck-ui pkgs.xdotool ];
  };
}