{ config, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.yusef.droidcam;
in {
    options.yusef.droidcam = {
        enable = mkEnableOption "Enable Droidcam support";
    };

    config = mkIf (cfg.enable) {
        # enable the snd-aloop module. video device setup is in ./v2l2loopback.nix
        boot.kernelModules = [ "snd-aloop" ];
        environment.systemPackages = [ pkgs.droidcam ];
    };
}