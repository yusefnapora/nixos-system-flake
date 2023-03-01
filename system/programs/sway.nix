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

    lock-timeout = mkOption {
      type = types.int;
      description = "Idle time in seconds before locking session";
      default = 600;
    };

    suspend-timeout = mkOption {
      type = types.int;
      description = "Idle time in seconds before suspending system";
      default = 1200;
    };

    nvidia = mkOption {
      type = types.bool;
      description = "Apply nvidia-specific hacks";
      default = false;
    };

    swaymonad = mkEnableOption "Enable swaymonad auto-tiling support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ 
      pkgs.wdisplays 
      pkgs.xorg.xcursorthemes 
      pkgs.vanilla-dmz
      pkgs.xfce.thunar
      pkgs.lxqt.lxqt-policykit # provides a default authentification client for policykit    
    ];
    programs.sway.enable = true;

    # enable browsing smb shares in thunar, etc
    # see: https://nixos.wiki/wiki/Samba#Browsing_samba_shares_with_GVFS
    services.gvfs.enable = true;  
  };
}
