{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.yusef.podman;
in
{
    options.yusef.podman = {
        enable = mkEnableOption "Enable podman container runtime";
    };

    config = mkIf cfg.enable {
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      virtualisation.oci-containers.backend = "podman";
      environment.systemPackages = [ pkgs.podman-compose pkgs.distrobox ];
    };
}
