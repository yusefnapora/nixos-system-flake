# The system dir contains nixos system configuration stuff
#

{ config, lib, pkgs, agenix, ... }:
{
  imports = [
    ./users
    ./programs
    ./modules
  ];


  options.yusef = {
    gui.enable = lib.mkEnableOption "Enables GUI programs";

    fish = {
      init = lib.mkOption {
        type = lib.types.lines;
        description = "added to fish initScript in home-manager config";
        default = "";
      };
    };

    system = lib.mkOption {
      type = lib.types.str;
      description = "nix system, e.g. x86_64-linux, aarch64-linux, etc";
      default = "x86_64-linux";
    };
  };


  config = {
    # enable ssh server
    services.openssh.enable = true;

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    # Set your time zone.
    time.timeZone = "America/New_York";

  };
}
