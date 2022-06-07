{ config, lib, pkgs, ...}:
let
  mod = "Mod4";
in
{
    xsession.windowManager.i3 = {
        enable = true;
        config = {
            modifier = mod;

            keybindings = {
                # focus window
                "${mod}+j" = "focus left";
                "${mod}+k" = "focus down";
                "${mod}+l" = "focus up";
                "${mod}+semicolon" = "focus right";
                "${mod}+Left" = "focus left";
                "${mod}+Down" = "focus down";
                "${mod}+Up" = "focus up";
                "${mod}+Right" = "focus right";

                # move window
                "${mod}+Shift+j" = "move left";
                "${mod}+Shift+k" = "move down";
                "${mod}+Shift+l" = "move up";
                "${mod}+Shift+semicolon" = "move right";
                "${mod}+Shift+Left" = "move left";
                "${mod}+Shift+Down" = "move down";
                "${mod}+Shift+Up" = "move up";
                "${mod}+Shift+Right" = "move right";

                # split horizontal/vertical
                "${mod}+h" = "split h";
                "${mod}+v" = "split v";

                # fullscreen
                "${mod}+f" = "fullscreen";

                # change container layout (stacking, tabbed, toggle split)
                "${mod}+s" = "layout stacking";
                "${mod}+w" = "layout tabbed";
                "${mod}+e" = "layout toggle split";

                # toggle tiling / floating
                "${mod}+Shift+space" = "floating toggle";

                # focus parent container
                "${mod}+a" = "focus parent";

                # dmenu
                "${mod}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";

                # switch to workspace
                "${mod}+1" = "workspace 1";
                "${mod}+2" = "workspace 2";
                "${mod}+3" = "workspace 3";
                "${mod}+4" = "workspace 4";
                "${mod}+5" = "workspace 5";
                "${mod}+6" = "workspace 6";
                "${mod}+7" = "workspace 7";
                "${mod}+8" = "workspace 8";
                "${mod}+9" = "workspace 9";
                "${mod}+0" = "workspace 10";

                # move focused container to workspace
                "${mod}+Shift+1" = "move container to workspace 1";
                "${mod}+Shift+2" = "move container to workspace 2";
                "${mod}+Shift+3" = "move container to workspace 3";
                "${mod}+Shift+4" = "move container to workspace 4";
                "${mod}+Shift+5" = "move container to workspace 5";
                "${mod}+Shift+6" = "move container to workspace 6";
                "${mod}+Shift+7" = "move container to workspace 7";
                "${mod}+Shift+8" = "move container to workspace 8";
                "${mod}+Shift+9" = "move container to workspace 9";
                "${mod}+Shift+0" = "move container to workspace 10";


                # terminal
                "${mod}+Return" = "exec kitty";


            };
        };
    };
}