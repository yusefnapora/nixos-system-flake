# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, apple-silicon, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/asahi.nix

      # apple-silicon hardware support
      apple-silicon.nixosModules.apple-silicon-support
      
      ../default.nix
    ];

  # custom options
  yusef = {
    system = "aarch64-linux";
    gui.enable = true;
    sound.enable = true;
    # i3 = { 
    #   enable = true;
    #   terminal = "alacritty";
    #   dpi-scale = 2.0;
    #   natural-scrolling = true;
    #   gaps = {};
    # };
    sway = {
      enable = true;
      natural-scrolling = true;
      terminal = "alacritty";
      dpi-scale = 2.0;
      output = {
        eDP-1 = {
          scale = "2";
        };
      };
    };
    docker.enable = true;
    key-remap = { 
      enable = true;
      caps-to-ctrl-esc = true;
    };
  };

  # asahi linux overlay
  nixpkgs.overlays = [ apple-silicon.overlays.apple-silicon-overlay ];

  # enable GPU support
  hardware.asahi.useExperimentalGPUDriver = true;

  # backlight control
  programs.light.enable = true;  
  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
    ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "asahi"; # Define your hostname.
  networking.networkmanager.enable = true;

  system.stateVersion = lib.mkForce "23.05";
}

