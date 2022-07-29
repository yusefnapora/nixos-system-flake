{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.yusef.docker;
in
{
    options.yusef.docker = {
        enable = mkEnableOption "Enable docker";
    };

    config = mkIf cfg.enable {
        virtualisation.docker.enable = true;
        virtualisation.oci-containers.backend = "docker";
        environment.systemPackages = [ pkgs.docker-compose ];
    };
}