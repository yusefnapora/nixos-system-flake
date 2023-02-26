# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:
{
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
    sway = {
      enable = true; 
      natural-scrolling = true;
      waybar-output = "HDMI-A-1";
    };
    key-remap = { 
      enable = true; 
      caps-to-ctrl-esc= true; 
      swap-left-alt-and-super = true;
    };
    docker.enable = true;
    droidcam.enable = true;
    obs.enable = true;
    streamdeck.enable = true;
    kindle.enable = true;
    kvm-host.enable = true;
    win-vm = {
      enable = true;
      vfio-pci-ids = [
        "10de:2208" # nvidia display device
        "10de:1aef" # nvidia audio device
      ];
      vfio-runtime-pci-devices = [
        "0000:05:00.0" # device path of nvme controller for windows SSD 
      ];
    };
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs.yusef) lgtv trim-screencast;
    # inherit (pkgs) looking-glass-client;
  };

  # doesn't seem to want to wake from hibernate...
  # systemd.targets.hibernate.enable = false;

  #powerManagement.resumeCommands = 
  #  ''
  #  echo "waking TV on resume from sleep"
  #  ${pkgs.yusef.lgtv}/bin/lgtv -c /root/.config/lgtv/config wakeonlan
  #  '';

  # enable iommu for GPU passthrough
  #boot.kernelParams = [ 
  #  "intel_iommu=on"
  #  "iommu=pt"
  #  "vfio-pci.ids=10de:2208,10de:1aef"
  #];

  #boot.initrd.kernelModules = [
  #  "vfio"
  #  "vfio_pci"
  #  "kvmfr"
  #];


  # add the kernel module for Looking Glass shared mem
  #boot.extraModulePackages = [
  #  config.boot.kernelPackages.kvmfr
  #];

  #boot.extraModprobeConfig = ''
  #  options kvmfr static_size_mb=128 
  #'';

  # allow access to the /dev/kvmfr0 shared memory device
  #services.udev.extraRules = ''
  #  SUBSYSTEM=="kvmfr", OWNER="yusef", GROUP="qemu-libvirtd", MODE="0660"
  #'';

  # configure looking-glass-client to use /dev/kvmfr0 
  #environment.etc."looking-glass-client.ini" = {
  #  user = "yusef";
  #  group = "kvm";

  #  text = ''
  #    [app]
  #    shmFile=/dev/kvmfr0
  #  '';
  #};


  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nobby"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  system.stateVersion = lib.mkForce "22.11";
}

