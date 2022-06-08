{ config, pkgs, ... }:
{

  programs.sway.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

}
