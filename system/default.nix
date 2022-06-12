# The system dir contains nixos system configuration stuff
#

{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
    ./users
    ./programs
    ./modules
  ];

  config = {

    # enable docker
    virtualisation.docker.enable = true;

    # enable ssh server
    services.openssh.enable = true;

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    # Set your time zone.
    time.timeZone = "America/NewYork";


    system.stateVersion = "21.11"; # magic - don't touch without googling first

  };
}