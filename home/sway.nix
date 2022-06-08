{ config, lib, pkgs, ... }:
{
    programs.fish.shellAliases = {
      # alias to set custom resolution on vmware guest.
      # TODO: move to vmware host config, or figure out why vmware tools isn't
      # auto-resizing like it should.
      swayres = "swaymsg -- output Virtual-1 mode --custom";
      sway4k = "swayres 3840x2160@120Hz";
      sway1440p = "swayres 2560x1440@120Hz";
      sway1600p = "swayres 2560x1600@120Hz";
    };

    programs.fish.loginShellInit = ''
    # if running from tty1, start sway
    set TTY1 (tty)

    # fix for black screen in vmware guest. TODO: move to vmware host config
    set -x WLR_NO_HARDWARE_CURSORS 1

    [ "$TTY1" = "/dev/tty1" ] && exec sway
    '';


    wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;

        terminal = "kitty";

        config = { 
          modifier = "Mod4";
          output."*" = { bg = "#aaaaaa solid_color"; };
        };

        extraSessionCommands = ''
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
        '';
    };

    # todo: launcher, swaybar, lock, etc
    
}
