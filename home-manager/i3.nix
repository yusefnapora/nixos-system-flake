{ config, lib, pkgs, nixosConfig, ...}:
with lib;
let
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

                gaps = {
                    inner = 10;
                    outer = 5;
                };

                keybindings = mkOptionDefault {
                    # terminal
                    "${mod}+Return" = "exec kitty";

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

                # polybar is started by home-manager's systemd service
                bars = [ ];

                startup = [
                  { command = "feh --bg-scale --zoom fill ${backgroundImage}"; }
                  { command = "i3-msg 'workspace 1'"; }
                ] ++ cfg.startup;
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
      inactiveOpacity = 0.8;
      menuOpacity = 0.8;

      backend = "xrender";
      vSync = true;

    };

    };
}