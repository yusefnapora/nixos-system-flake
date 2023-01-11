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
      dpi-scale = 2.0;
    };
    key-remap = { 
      enable = true; 
      caps-to-ctrl-esc = true; 
    };
    docker.enable = true;
    droidcam.enable = true;
    obs.enable = true;
    kvm-host.enable = true;
  };

  environment.systemPackages = with pkgs; [
    yusef.trim-screencast
    libva-utils # for sanity-checking video acceleration
  ];

  # doesn't seem to want to wake from hibernate...
  systemd.targets.hibernate.enable = false;

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


  # Thunderbolt
  services.hardware.bolt.enable = true;


  # display config for LG Ultrafine 5k
  # it's a bit quirky, since it shows up as two displayport outputs
  # that need to be stitched together
  # 
  # This config is equivalent to this xrandr command:
  # xrandr --output DP-3 --mode 2560x2880 --output DP-4 --mode 2560x2880 --right-of DP-3
  services.xserver = {
    xrandrHeads = [
      {
        output = "DP-3";
        monitorConfig = ''
          Option "PreferredMode" "2560x2880"
        '';
      }
      {
        output = "DP-4";
        monitorConfig = ''
          Option "PreferredMode" "2560x2880"
          Option "RightOf" "DP-3"
        '';
      }
    ];

    # hi-dpi config
    dpi = 218;
    displayManager.sessionCommands = ''
      ${pkgs.xorg.xrdb}/bin/xrdb -merge <${pkgs.writeText "Xresources" ''
        Xft.dpi: 218
        Xcursor.theme: Adwaita
        Xcursor.size: 48
        Xcursor.theme_core: 1
      ''}
    '';    
  };


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "musicbox"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.enp88s0.useDHCP = true;

  system.stateVersion = lib.mkForce "22.11";
}

