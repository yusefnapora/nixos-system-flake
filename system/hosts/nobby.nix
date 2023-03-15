# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:
let 
  # eth-interface = "enp0s20f0u7u2u1";
  eth-interface = "enp0s20f0u2";
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/nobby.nix

      ../default.nix
    ];

  # custom options
  yusef = {
    gui.enable = true;
    sound.enable = true;
    bluetooth.enable = true;
    nixpkgs-wayland.enable = true;
    sway = {
      enable = true; 
      natural-scrolling = true;
      nvidia = true;
      no-hardware-cursors-fix = true;
    };
    key-remap = { 
      enable = true; 
      caps-to-ctrl-esc= true; 
      swap-left-alt-and-super = true;
    };
    podman.enable = true;
    droidcam.enable = true;
    obs.enable = true;
    streamdeck.enable = true;
    kindle.enable = true;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs) pciutils usbutils;
    inherit (pkgs.yusef) lgtv trim-screencast;
  };

  # doesn't seem to want to wake from hibernate...
  # systemd.targets.hibernate.enable = false;

  #powerManagement.resumeCommands = 
  #  ''
  #  echo "waking TV on resume from sleep"
  #  ${pkgs.yusef.lgtv}/bin/lgtv -c /root/.config/lgtv/config wakeonlan
  #  '';

  # nvidia GPU setup
  hardware.nvidia = {
    # use open-source driver
    #open = true;
    #package = config.boot.kernelPackages.nvidiaPackages.beta;

    modesetting.enable = true;
    powerManagement.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  # "nuclear" fix for random flickering
  # see: https://wiki.hyprland.org/hyprland-wiki/pages/Nvidia/
  #boot.extraModprobeConfig = ''
  #  options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3"
  ##'';

  # turn off hi-dpi console mode
  hardware.video.hidpi.enable = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nobby"; # Define your hostname.


  networking.useDHCP = false;
  networking.interfaces.${eth-interface}.useDHCP = true;

  system.stateVersion = "22.11";
}

