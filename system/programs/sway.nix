# modified from https://github.com/Xe/nixos-configs/blob/0624176ee2d30c4c778730216f5bddc704ff2f24/common/programs/sway.nix
{ config, pkgs, lib, ... }:

with lib;
let cfg = config.yusef.sway;
in {
  options.yusef.sway = {
    enable = mkEnableOption "sway";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wdisplays ];
    programs.sway.enable = true;
  };
}