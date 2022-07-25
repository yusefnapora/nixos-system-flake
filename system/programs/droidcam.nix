{ config, pkgs, lib, ... }:
with lib;
let cfg = config.yusef.droidcam;
in {

    options.yusef.droidcam = {
        enable = mkEnableOption "Enable Droidcam support";
    };

    config = mkIf (cfg.enable) {
        # enable the v4l2loopback and snd-aloop modules
        boot.extraModulePackages = with config.boot.kernelPackages; [
            v4l2loopback.out
        ];

        boot.kernelModules = [
            "v4l2loopback"
            "snd-aloop"
        ];

        boot.extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 video_nr=1 card_label="Virtual Camera (droidcam)"
        '';

        environment.systemPackages = [ pkgs.droidcam ];
    };

}