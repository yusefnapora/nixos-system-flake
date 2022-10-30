# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/nuc11.nix

      ../default.nix
    ];

  # custom options
  yusef = {
    gui.enable = true;
    _1password.enable = true;
    sound.enable = true;
    bluetooth.enable = true;
    i3 = {
      enable = true; 
      natural-scrolling = true;
    };
    key-remap = { 
      enable = true; 
      caps-to-ctrl-esc= true; 
      swap-left-alt-and-super= true; 
    };
    docker.enable = true;
    droidcam.enable = true;
    kvm-switch.enable = true;
    obs.enable = true;
    streamdeck.enable = true;
    kindle.enable = true;
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

  environment.systemPackages = with pkgs; [
    yusef.lgtv
    yusef.trim-screencast
    libva-utils # for sanity-checking video acceleration
  ];

  # doesn't seem to want to wake from hibernate...
  systemd.targets.hibernate.enable = false;

  powerManagement.resumeCommands = 
    ''
    echo "waking TV on resume from sleep"
    ${pkgs.yusef.lgtv}/bin/lgtv -c /root/.config/lgtv/config wakeonlan
    '';

  services.logind.extraConfig = ''
    # set power button to suspend instead of poweroff
    HandlePowerKey=suspend
    # suspend when idle timer kicks in
    IdleAction=suspend
    IdleActionSec=45m
  '';

  # enable hw-accelerated video playback for intel GPU
  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
  };

  hardware.opengl = lib.mkForce {
    enable = true;
    driSupport = true;
    # driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nux"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.enp88s0.useDHCP = true;

}

