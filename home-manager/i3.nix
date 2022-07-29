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
                };

                # polybar is started by home-manager's systemd service
                bars = [ ];

                startup = [
                  { command = "feh --bg-scale --zoom fill ${backgroundImage}"; }
                ];
            };
        };

        services.polybar = {
            enable = true;
            package = (pkgs.polybar.override { i3GapsSupport = true; });
            script = ''
            #!/usr/bin/env bash

            # Terminate already running bar instances
            # If all your bars have ipc enabled, you can use 
            polybar-msg cmd quit
            # Otherwise you can use the nuclear option:
            # killall -q polybar

            echo "---" | tee -a /tmp/polybar.log
            polybar 2>&1 | tee -a /tmp/polybar.log & disown

            echo "Bars launched..."
            '';
            settings = {
              "bar/bottom" = {
                bottom = true;
                width = "100%";
                height = 30;
                offset-y = 0;
                fixed-center = true;
                # override-redirect = true;
                # wm-restack = "i3";
                scroll-up = "next";
                scroll-down = "prev";
                enable-ipc = true;
                background = "\${colors.trans}";
                foreground = "\${colors.fg}";
                tray-background = "\${colors.bg-alt}";
                tray-position = "right";
                tray-maxsize = 16;

                modules-left = "date round-right";
                modules-center = "round-left i3 round-right";
                # modules-right = "round-left mpd";
                # modules.right = [ "clock" ];

                font-0 = "JetBrainsMono Nerd Font:style=Normal:size=9;3";
                font-1 = "JetBrainsMono Nerd Font:style=Medium:size=9;3";
                font-2 = "JetBrainsMono Nerd Font:style=Bold:size=9;3";
                font-3 = "JetBrainsMono Nerd Font:style=Italic:size=9;3";
                font-4 = "JetBrainsMono Nerd Font:style=Medium Italic:size=9;3";
                font-5 = "JetBrainsMono Nerd Font:size=19;5";
                font-6 = "feathericon:size=10.4;3.5";
                font-7 = "Material Icons:size=11;4";
                font-8 = "Material Icons Outlined:size=11;4";
                font-9 = "Material Icons Round:size=11;4";
                font-10 = "Material Icons Sharp:size=11;4";
                font-11 = "Material Icons TwoTone:size=11;4";
              };

              colors = {
                bg = "#2E3440";
                bg-alt = "#3B4252";
                fg = "#ECEFF4";
                fg-alt = "#E5E9F0";

                blue = "#81A1C1";
                cyan = "#88C0D0";
                green = "#A3BE8C";
                orange = "#D08770";
                purple = "#B48EAD";
                red = "#BF616A";
                yellow = "#EBCB8B";

                black = "#000";
                white = "#FFF";

                trans = "#00000000";
                semi-trans-black = "#aa000000";
              };

              "module/i3" = {
                type = "internal/i3";
                index-sort = true;
                format = "<label-state> <label-mode>";
                format-background = "\${colors.bg-alt}";

                label-mode = "%{T2}%mode%%{T-}";
                label-mode-padding = 1;
                label-mode-background = "\${colors.purple}";

                label-focused = "%index%";
                label-focused-foreground = "\${colors.green}";
                label-focused-padding = 1;

                label-unfocused = "%index%";
                label-unfocused-foreground = "\${colors.orange}";
                label-unfocused-padding = 1;

                label-visible = "%index%";
                label-visible-foreground = "\${colors.blue}";
                label-visible-padding = 1;

                label-urgent = "%index%";
                label-urgent-foreground = "\${colors.red}";
                label-urgent-padding = 1;
              };

              "module/date" = {
                type = "internal/date";
                format = "<label>";
                format-prefix = "%{T10}%{T-}";
                format-prefix-background = "\${colors.green}";
                format-prefix-foreground = "\${colors.bg}";
                format-prefix-padding = 1;
                label = "%{T2}%time%%{T-}";
                label-background = "\${colors.bg-alt}";
                label-foreground = "\${colors.fg}";
                label-padding = 1;
                interval = 1;
                time = " %I:%M %p";
                time-alt = " %a, %b %d %I:%M:%S %p";
              };

              "module/margin" = {
                type = "custom/text";
                content = "%{T1} %{T-}";
                content-foreground = "\${colors.trans}";
              };

              "module/round-left" = {
                type = "custom/text";
                content = "%{T6}%{T-}";
                content-foreground = "\${colors.bg-alt}";
              };

              "module/round-right" = {
                type = "custom/text";
                content = "%{T6}%{T-}";
                content-foreground = "\${colors.bg-alt}";
              };
            };
        };
    };
}