{ config, nixosConfig, lib, pkgs, ... }:
with lib;
let
  cfg = nixosConfig.yusef.sway;

  # fix for invisible cursor when running in vmware
  hardwareCursorsFix = strings.optionalString cfg.no-hardware-cursors-fix ''
    set -x WLR_NO_HARDWARE_CURSORS 1
  '';

in {
  config = mkIf (cfg.enable) {

    programs.fish.loginShellInit = ''
    # if running from tty1, start sway
    set TTY1 (tty)
    ${hardwareCursorsFix}
    [ "$TTY1" = "/dev/tty1" ] && exec sway
    '';

    wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;

        config = { 
          modifier = "Mod4";
          terminal = cfg.terminal;
          output = cfg.output;

          input."type:pointer" = mkIf cfg.natural-scrolling { 
            natural_scroll = "enabled";
          };

          startup = cfg.startup-commands;

          bars = [
            {
              command = "waybar";
            }
          ];
        };

        extraSessionCommands = ''
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
        export _JAVA_AWT_WM_NONREPARENTING=1
        '';
    };


    # waybar
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          output = [
            "eDP-1"
          ];
          modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
          modules-center = [ "sway/window" ];
          modules-right = ["clock" "mpd" "tray" ];

          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
          };

          clock = {
            format = "{:%I:%M %p}";       
          };

          "wlr/taskbar" = {
            on-click = "activate";
          };
        };
};
    };

    # todo: launcher, swaybar, lock, etc
  };
}