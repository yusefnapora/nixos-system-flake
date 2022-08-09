{ config, lib, pkgs, nixosConfig, ...}:
let
  inherit (lib) mkIf mkOptionDefault mkForce;

  cfg = nixosConfig.yusef.i3;
  mod = "Mod4";
  backgroundImage = (builtins.path { name = "jwst-carina.jpg"; path = ./backgrounds/jwst-carina.jpg; });
in
{
    config = mkIf cfg.enable {
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

                # rofi
                "${mod}+d" = "exec --no-startup-id rofi -show drun";

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
      shadowExclude = [ "window_type *= 'normal' && ! name ~= ''" ];

      activeOpacity = 1.0;

      # set kitty (terminal) windows to 80% opacity when unfocused.
      # using this instead of inactiveOpacity, since the latter is
      # too distracting when e.g. coding with a web-browser in split screen
      opacityRules = [
        ''
        80: class_i = "kitty" && focused != 1
        ''
      ];

      backend = "xrender";
      vSync = true;

    };

    };
}