# Installs Trilium notes server using docker, since the current NixOS package is x86 only.
{ pkgs, config, lib, ...}:
with lib;
let
  cfg = config.yusef.trilium;
in
{
  options.yusef.trilium = {
    enable = mkEnableOption "Enable Trillium notes server";
  };

  config = mkIf cfg.enable {
    # TODO: assert that docker is also enabled
    virtualisation.oci-containers.containers."trilium-server" = {
      image = "zadam/trilium:0.53.2";
      ports = [ "127.0.0.1:8080:8080" ];
      volumes = [ "/root/trilium-data:/home/node/trilium-data" ];
    };
  };
}