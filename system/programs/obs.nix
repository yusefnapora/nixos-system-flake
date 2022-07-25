{ pkgs, config, lib, ...}:
with lib;
let
  cfg = config.yusef.obs;
in {
  options.yusef.obs = {
    enable = mkEnableOption "Install OBS Studio and plugins";
  };

  config = mkIf cfg.enable {
    # enable the v4l2loopback and snd-aloop modules
    boot.extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback.out
    ];

    boot.kernelModules = [
        "v4l2loopback"
    ];

    boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 video_nr=2 card_label="OBS Virtual camera"
    '';

    environment.systemPackages = with pkgs; [
      obs-studio
      obs-studio-plugins.wlrobs
    ];

  };
}