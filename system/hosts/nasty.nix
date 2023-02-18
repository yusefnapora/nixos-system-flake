# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/nasty.nix

      ../default.nix
    ];

  # custom options
  yusef = {
    key-remap = { 
      enable = true; 
      caps-to-ctrl-esc= true; 
      # swap-left-alt-and-super= true; 
    };
    docker.enable = true;
  };

  # enable ZFS
  # see: https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/index.html  
  boot.supportedFilesystems = [ "zfs" ];
  # set hostId to first 8 chars of /etc/machine-id
  networking.hostId = "f94f2c6c";
  # import pools on boot
  boot.zfs.extraPools = [ "ocean" ];

  systemd.targets.hibernate.enable = false;

  # Samba config
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = nasty
      netbios name = nasty
      security = user
      hosts allow = 192.168.86. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = let 
      common_attrs = {
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "yusef";
        "force group" = "users";      
      };
    in {
      media = {
        path = "/ocean/media";
      } // common_attrs;
      documents = {
        path = "/ocean/documents";
      } // common_attrs;
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nasty"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.enp3s0.useDHCP = true;

}

