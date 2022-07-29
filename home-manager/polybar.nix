{ pkgs, lib, config, nixosConfig, ... }:
with lib;
let
  inherit (lib.strings) floatToString;
  enable = nixosConfig.yusef.i3.enable;
  dpi-scale = nixosConfig.yusef.i3.dpi-scale;

  scaled = size: (floatToString (size * dpi-scale));

  font-size-text-regular = (scaled 9.0);
  font-size-text-large = (scaled 19.0);
  font-size-material-icons = (scaled 11.0);
  font-size-feather-icons = (scaled 10.4);
  font-offset-text = (scaled 3.0);
  font-offset-text-large = (scaled 5.0);
  font-offset-feather-icons = (scaled 3.5);
  font-offset-material-icons = (scaled 4.0);
in
{
  config = mkIf enable {
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
            height = 30 * dpi-scale;
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

            modules-left = "i3 round-right";
            modules-center = "round-left title round-right";
            modules-right = "round-left date";

            font-0 = "JetBrainsMono Nerd Font:style=Normal:size=${font-size-text-regular};${font-offset-text}";
            font-1 = "JetBrainsMono Nerd Font:style=Medium:size=${font-size-text-regular};${font-offset-text}";
            font-2 = "JetBrainsMono Nerd Font:style=Bold:size=${font-size-text-regular};${font-offset-text}";
            font-3 = "JetBrainsMono Nerd Font:style=Italic:size=${font-size-text-regular};${font-offset-text}";
            font-4 = "JetBrainsMono Nerd Font:style=Medium Italic:size=${font-size-text-regular};${font-offset-text}";
            font-5 = "JetBrainsMono Nerd Font:size=${font-size-text-large};${font-offset-text-large}";
            font-6 = "feathericon:size=${font-size-feather-icons};${font-offset-feather-icons}";
            font-7 = "Material Icons:size=${font-size-material-icons};${font-offset-material-icons}";
            font-8 = "Material Icons Outlined:size=${font-size-material-icons};${font-offset-material-icons}";
            font-9 = "Material Icons Round:size=${font-size-material-icons};${font-offset-material-icons}";
            font-10 = "Material Icons Sharp:size=${font-size-material-icons};${font-offset-material-icons}";
            font-11 = "Material Icons TwoTone:size=${font-size-material-icons};${font-offset-material-icons}";
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

            trans = "#00ffffff";
            semi-trans-black = "#aa000000";
          };

          "module/title" = {
            type = "internal/xwindow";
            format = "<label>";
            label-foreground = "\${colors.fg}";
            format-background = "\${colors.bg-alt}";
          };

          "module/i3" = {
            type = "internal/i3";
            index-sort = true;
            format = "<label-state> <label-mode>";
            format-background = "\${colors.bg-alt}";
            format-prefix = "%{T10}%{T-}";
            format-prefix-background = "\${colors.cyan}";
            format-prefix-padding = 1;

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
            format-suffix = "%{T10}%{T-}";
            format-suffix-background = "\${colors.green}";
            format-suffix-foreground = "\${colors.bg}";
            format-suffix-padding = 1;
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
            content-background = "\${colors.bg-alt}";
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