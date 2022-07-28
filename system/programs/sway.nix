# modified from https://github.com/Xe/nixos-configs/blob/0624176ee2d30c4c778730216f5bddc704ff2f24/common/programs/sway.nix
{ config, pkgs, lib, ... }:

with lib;
let cfg = config.yusef.sway;
in {
  options.yusef.sway = {
    enable = mkEnableOption "sway";

    # options below are used in home-manager config
    natural-scrolling = mkOption {
      type = types.bool;
      description = "Set all mouse inputs to \"natural\" (reversed) scrolling";
      default = false;
    };

    no-hardware-cursors-fix = mkOption {
      type = types.bool;
      description = "Set WLR_NO_HARDWARE_CURSORS to fix issues with rendering in VM guests";
      default = false;
    };

    startup-commands = mkOption {
      type = types.listOf types.attrs;
      description = "Extra stuff to add to home-manager's sway.extraSessionCommands option";
      default = [];
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ 
      wdisplays 
      glib
      grim
      slurp
      wl-clipboard
      mako 
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      xdg-utils
    ];
    programs.sway = { 
      enable = true;
      wrapperFeatures.gtk = true; 
    };

    services.dbus.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
    };
  };
}