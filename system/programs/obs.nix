{ pkgs, config, lib, ...}:
with lib;
let
  cfg = config.yusef.obs;
in {
  options.yusef.obs = {
    enable = mkEnableOption "Install OBS Studio and plugins";
  };

  config = mkIf cfg.enable {
    # See ./v4l2loopback.nix for virtual camera video device stuff

    environment.systemPackages = with pkgs; [
      obs-studio
      obs-studio-plugins.wlrobs
    ];

  };
}