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
      waybar-output = "DP-1";
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
    usb-wake.devices = [
      { # ms keyboard receiver
        vendor-id = "045e";
        product-id = "07a5"; 
      }
      { # logitech mouse receiver
        vendor-id = "046d";
        product-id = "c52b";
      }
      { # streamdeck 
        vendor-id = "0fd9";
        product-id = "0080";
      }
      # somewhat annoyingly, you need to enable wakeup for the usb host controller & the hub they're plugged into also
      { # usb1 and usb3 xHCI controller
        vendor-id = "1d6b";
        product-id = "0002";
      }
      { # usb2 and usb4 xHCI controller
        vendor-id = "1d6b";
        product-id = "0003";
      }
      { # usb 2.0 hub (assuming this is the usb switch) 
        vendor-id = "2109";
        product-id = "2817";
      }
    ];
  };

  environment.systemPackages = [
    pkgs.yusef.lgtv
    pkgs.yusef.trim-screencast
    pkgs.libva-utils # for sanity-checking video acceleration
  ];

  # doesn't seem to want to wake from hibernate...
  # systemd.targets.hibernate.enable = false;

  #powerManagement.resumeCommands = 
  #  ''
  #  echo "waking TV on resume from sleep"
  #  ${pkgs.yusef.lgtv}/bin/lgtv -c /root/.config/lgtv/config wakeonlan
  #  '';

  # enable iommu for GPU passthrough
  boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];

  # use vfio-pci for Nvidia GPU, so we can pass it through to windows VM
  boot.extraModprobeConfig = ''
    options vfio-pci ids=10de:2208,10de:1aef
  '';

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nobby"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  system.stateVersion = lib.mkForce "22.11";
}

