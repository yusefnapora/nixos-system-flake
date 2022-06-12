# remap capslock to control when held, escape when tapped
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.yusef.key-remap;
in
{

  options.yusef.key-remap = {
    enable = mkEnableOption "Enable to set Caps Lock to Control when held & Esc when tapped";
  };

  config = mkIf cfg.enable {
    environment.etc."dual-function-keys.yaml".text = '' 
      MAPPINGS:
        - KEY: KEY_CAPSLOCK
          TAP: KEY_ESC
          HOLD: KEY_LEFTCTRL
    '';

    services.interception-tools = { 
      enable = true;
      plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
      udevmonConfig = ''
        - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /etc/dual-function-keys.yaml | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
      '';
    };
  };
}
