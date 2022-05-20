# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # x11 stuff
      ./gui.nix
    ];

  # allow unfree (vscode, etc)
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
  experimental-features = nix-command flakes
  '';

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/NewYork";

  networking.useDHCP = false;
  networking.interfaces.enp0s6.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yusef = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [
    vim 
    wget
    firefox
    fish
    git
  ];

  services.openssh.enable = true;

  system.stateVersion = "21.11"; # magic - don't touch without googling first

}

