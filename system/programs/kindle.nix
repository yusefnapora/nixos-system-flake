{ pkgs, lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.yusef.kindle;
in {

  options.yusef.kindle = {
    enable = mkEnableOption "Enable DeDRM-compatible Kindle via Wine";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.yusef.kindle
    ];

    # Kindle 1.17 needs a special certificate file to access the network.
    # see: https://askubuntu.com/a/1352999
    security.pki.certificateFiles = [
      ./kindle-verisign-cert.crt
    ];
  };

}