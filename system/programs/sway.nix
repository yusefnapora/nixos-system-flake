# modified from https://github.com/Xe/nixos-configs/blob/0624176ee2d30c4c778730216f5bddc704ff2f24/common/programs/sway.nix
{ config, pkgs, lib, ... }:

with lib;
let cfg = config.yusef.sway;
in {
  options.yusef.sway = {
    enable = mkEnableOption "sway";

    terminal = mkOption {
      type = types.str;
      description = "default terminal emulator";
      default = "kitty";
    };
    
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

    output = mkOption {
      type = types.attrs;
      description = "Sway output config (see home-manager docs)";
      default = {};
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ wdisplays ];
    programs.sway.enable = true;
  };
}