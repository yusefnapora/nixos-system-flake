{ config, lib, pkgs, ... }:
{
  options.yusef.tailscale.enable = lib.mkEnableOption "Enable tailscale VPN";
  
  config = lib.mkIf config.yusef.tailscale.enable {
    environment.systemPackages = [ pkgs.tailscale ];

    services.tailscale.enable = true;

    networking.firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };
}
