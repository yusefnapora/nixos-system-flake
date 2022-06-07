{ config, pkgs, ... }:
{
  imports = [
      ../gui.nix
  ];

  # allow unfree (vscode, etc)
  nixpkgs.config.allowUnfree = true;

  # enable docker
  virtualisation.docker.enable = true;

  # enable nix flakes
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
  experimental-features = nix-command flakes
  '';

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";


  # Set your time zone.
  time.timeZone = "America/NewYork";

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
  system.stateVersion = "22.05"; # magic - don't touch without googling first
}