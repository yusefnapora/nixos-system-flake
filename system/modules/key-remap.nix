# remap capslock to control when held, escape when tapped
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.strings) optionalString concatStringsSep;
  inherit (lib.lists) optionals;
  cfg = config.yusef.key-remap;

  keys-to-listen-for = 
    optionals cfg.caps-to-ctrl-esc ["KEY_CAPSLOCK" "KEY_ESC"] 
    ++ optionals cfg.swap-left-alt-and-super [ "KEY_LEFTALT" "KEY_LEFTMETA"];

  listen-key-string = (concatStringsSep ", " keys-to-listen-for);
  
in
{

  options.yusef.key-remap = {
    enable = mkEnableOption "Enable key remapping with interception-tools";
    caps-to-ctrl-esc = mkEnableOption "Enable to set Caps Lock to Control when held & Esc when tapped";
    swap-left-alt-and-super = mkEnableOption "Swap left super key with alt";
  };

  config = mkIf cfg.enable {
    environment.etc."dual-function-keys.yaml".text = '' 
      MAPPINGS:
      '' + optionalString cfg.caps-to-ctrl-esc 
      ''# capslock to ctrl when held, esc when tapped
        - KEY: KEY_CAPSLOCK
          TAP: KEY_ESC
          HOLD: KEY_LEFTCTRL
      '' + optionalString cfg.swap-left-alt-and-super 
      ''# swap left alt and super keys
        - KEY: KEY_LEFTALT
          TAP: KEY_LEFTMETA
          HOLD: KEY_LEFTMETA
          HOLD_START: BEFORE_CONSUME
        - KEY: KEY_LEFTMETA
          TAP: KEY_LEFTALT
          HOLD: KEY_LEFTALT
          HOLD_START: BEFORE_CONSUME
      '';

    services.interception-tools = { 
      enable = true;
      plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
      udevmonConfig = ''
        - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /etc/dual-function-keys.yaml | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [${listen-key-string}]
      '';
    };
  };
}
