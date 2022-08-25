{ config, lib, pkgs, nixosConfig, ...}:
let
  inherit (lib) mkIf mkOptionDefault mkForce;

  cfg = nixosConfig.yusef.i3;
  mod = "Mod4";
  alt = "Mod1";
  backgroundImage = (builtins.path { name = "jwst-carina.jpg"; path = ./backgrounds/jwst-carina.jpg; });

  # TODO: make an option for this?
  screenshots-dir = "/home/yusef/Screenshots";
in
{
    config = mkIf cfg.enable {
      home.packages = [
        pkgs.flameshot
      ];

      programs.feh.enable = true;

      xsession.enable = true;
      
      xsession.windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;

        config = {
            modifier = mod;

            gaps = cfg.gaps;

            keybindings = mkOptionDefault {
                # terminal
                "${mod}+Return" = "exec kitty";

                # rofi drun on Mod+d and Mod+Space
                "${mod}+d" = "exec --no-startup-id rofi -show drun";
                "${mod}+space"= "exec --no-startup-id rofi -show drun";

                # rofi emoji picker on Mod+Shift+space
                "${mod}+Shift+space" = "exec --no-startup-id rofi -show emoji";

                # rofi window switcher on Mod+Tab
                "${mod}+Tab" = "exec --no-startup-id rofi -show window";

                # move the default commands for Mod+space and Mod+Shift+space to Mod+o / Mod+Shift+o
                "${mod}+o" = "focus mode_toggle";
                "${mod}+Shift+o" = "floating toggle";

                # screenshots:
                ## PrintScreen and Mod+Shift+S (for keyboards without print screen key) to flameshot gui
                "Print" = "exec flameshot gui -p ${screenshots-dir}";
                "${mod}+Shift+s" = "exec flameshot gui -p ${screenshots-dir}";

                ## Shift+PrintScreen and Mod+Alt+Shift+S to full screen capture
                "Shift+Print" = "exec flameshot full -p ${screenshots-dir}";
                "${mod}+${alt}+Shift+s" = "exec flameshot full -p ${screenshots-dir}";

                # alternative to mod+shift+q, since macos insists on eating it
                "${mod}+Shift+w" = "kill";

                # alternative to mod+w for tabs, since t is for tabs
                "${mod}+t" = "layout tabbed";

                # vim-style focus / movement
                "${mod}+h" = "focus left";
                "${mod}+j" = "focus down";
                "${mod}+k" = "focus up";
                "${mod}+l" = "focus right";
                "${mod}+Shift+h" = "move left";
                "${mod}+Shift+j" = "move down";
                "${mod}+Shift+k" = "move up";
                "${mod}+Shift+l" = "move right";

                # split horizontal moves to Mod+b, since Mod+h is repurposed
                "${mod}+v" = "split v";
                "${mod}+b" = "split h";
            };

            colors.focused = {
              border = "#00AF91";
              childBorder = "#007965";
              background = "#285577";
              text = "#ffffff";
              indicator = "#2e9ef4";
            };

            # polybar is started by home-manager's systemd service
            bars = [ ];

            startup = cfg.startup ++ [
              { command = "feh --bg-scale --zoom fill ${backgroundImage}"; }
              { command = "i3-msg 'workspace 1'"; }
            ];

            floating.modifier = mod;

            floating.criteria = [
              { title = ".zoom "; }
            ];
        };
    };
       
    # enable picom compositor, so we can have transparency in polybar & other cool stuff
    services.picom = {
      enable = true;
      experimentalBackends = true;

      # blur = true;
      fade = true;
      fadeDelta = 5;

      shadow = true;
      shadowOffsets = [ (-7) (-7) ];
      shadowOpacity = 0.7;
      shadowExclude = [ 
        "window_type *= 'normal' && ! name ~= ''"
        "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'" # don't draw multiple shadows for tabbed windows
        "class_g = 'firefox' && argb" # fix odd shadows for some firefox windows
          "class_i = 'rofi'" # disable shadows for rofi to fix odd corner rendering
      ];

      activeOpacity = 1.0;

      # set kitty (terminal) windows to 80% opacity when unfocused.
      # using this instead of inactiveOpacity, since the latter is
      # too distracting when e.g. coding with a web-browser in split screen
      opacityRules = [
        "80: class_i = 'kitty' && focused != 1"
      
        # don't render hidden windows (prevents semi-transparent tabbed windows)
        "0:_NET_WM_STATE@[0]:32a *= '_NET_WM_STATE_HIDDEN'"
        "0:_NET_WM_STATE@[1]:32a *= '_NET_WM_STATE_HIDDEN'"
        "0:_NET_WM_STATE@[2]:32a *= '_NET_WM_STATE_HIDDEN'"
        "0:_NET_WM_STATE@[3]:32a *= '_NET_WM_STATE_HIDDEN'"
        "0:_NET_WM_STATE@[4]:32a *= '_NET_WM_STATE_HIDDEN'"
      ];

      backend = "xrender";
      vSync = true;

    };

    };
}