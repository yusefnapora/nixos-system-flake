{ pkgs, config, lib, ...}:
let
  inherit (lib) mkEnableOption mkIf;
  
  cfg = config.yusef.obs;
in {
  options.yusef.obs = {
    enable = mkEnableOption "Install OBS Studio and plugins";
  };

  # obs is actually installed via home-manager, since it's a litte easier to add plugins.
  # see ./v4l2loopback.nix for virtual camera config.
}