{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.yusef.bluetooth;
in
{
  options.yusef.bluetooth = {
    enable = mkEnableOption "Enable bluetooth";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}