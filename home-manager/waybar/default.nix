{ lib, config, pkgs, nixosConfig, ... }:
let 
  cfg = nixosConfig.yusef.sway;
  output = cfg.waybar-output;
in {
  programs.waybar = {
    enable = cfg.enable;
    style = ./style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [
          output
        ];
        modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "tray" "clock" "pulseaudio" "battery" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };

        clock = {
          format = "{:%I:%M %p}";
          tooltip-format = "{:%A, %B %m, %Y}";
        };

        "wlr/taskbar" = {
          on-click = "activate";
        };

        battery = {
          interval = 60;
          states = {
            warning = 20;
            critical = 10;
          };
          format = "{capacity}% {icon}";
          format-icons = ["" "" "" "" ""];
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            headphone =  "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
        };
      };
    };
  };
}
