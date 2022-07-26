{ pkgs, lib, config, ...}:
with lib;
let
  droidcam = config.yusef.droidcam;
  obs = config.yusef.obs;

  # we always create both video devices if at least one is enabled,
  # just because conditional logic is annoying in nix and it's simpler
  # this way.
  # We do change the labels though - if you've enabled droidcam, the device will
  # be labeled "Virtual Camera (Droidcam)" instead of "Video loopback 1".
  dev-0-label = if obs.enable then "Virtual Camera - OBS" else "Video loopback 0";
  dev-1-label = if droidcam.enable then "Virtual Camera - Droidcam" else "Video loopback 1";
in
{
  config = mkIf (droidcam.enable || obs.enable) {
    boot.extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback.out
    ];

    boot.kernelModules = [
        "v4l2loopback"
    ];

    # 
    boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 video_nr=0,1 card_label="${dev-0-label}","${dev-1-label}"
    '';
  }; 
}
