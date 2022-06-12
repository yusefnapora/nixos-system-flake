{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.yusef.sound;
in
{
    options.yusef.sound = {
        enable = mkEnableOption "Enable sound support";
    };

    config = mkIf (cfg.enable) {

        sound.enable = true;
        hardware.pulseaudio.enable = true;
        
    };
}