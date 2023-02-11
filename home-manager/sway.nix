{ config, nixosConfig, lib, pkgs, ... }:
with lib;
let
  cfg = nixosConfig.yusef.sway;

  # fix for invisible cursor when running in vmware
  hardwareCursorsFix = strings.optionalString cfg.no-hardware-cursors-fix ''
    set -x WLR_NO_HARDWARE_CURSORS 1
  '';

  cursor-size = builtins.ceil (32 * cfg.dpi-scale);
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

          input."type:touchpad" = mkIf cfg.natural-scrolling { 
            natural_scroll = "enabled";
          };

          keybindings = 
            let
              modifier = config.wayland.windowManager.sway.config.modifier;
            in lib.mkOptionDefault {
              "${modifier}+space" = "exec ${pkgs.albert}/bin/albert show";
            };
          
          startup = [
            { command = "${pkgs.albert}/bin/albert"; }
          ] ++ cfg.startup-commands;

          bars = [
            {
              command = "waybar";
            }
          ];

          # fix tiny cursor on hi-dpi screen
          seat."*".xcursor_theme = "Vanilla-DMZ ${builtins.toString cursor-size}";
        };

        extraSessionCommands = ''
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
        export _JAVA_AWT_WM_NONREPARENTING=1
        '';
    };

    # more hi-dpi cursor config
    home.pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = cursor-size;
      gtk.enable = true;
    };

    # yet more hidpi stuff, this time for electron apps (vscode, obsidian, etc)
    # see: https://github.com/microsoft/vscode/issues/136390#issuecomment-1340891893
    programs.fish.shellAliases = {
      code = "code --enable-features=WaylandWindowDecorations --ozone-platform=wayland";
      obsidian = "OBSIDIAN_USE_WAYLAND=1 obsidian -enable-features=UseOzonePlatform -ozone-platform=wayland";
      "1password" = "1password -enable-features=UseOzonePlatform -ozone-platform=wayland";
    };

    # apply hi-dpi hacks to desktop entries
    xdg.desktopEntries = {
      code = {
        name = "VSCode";
        terminal = false;
        icon = "${pkgs.vscode}/lib/vscode/resources/app/resources/linux/code.png";
        exec = "code --enable-features=WaylandWindowDecorations --ozone-platform=wayland";
      };
      obsidian = {
        name = "Obsidian";
        terminal = false;
        icon = "${pkgs.obsidian}/share/icons/hicolor/256x256/apps/obsidian.png";        
        exec = "env OBSIDIAN_USE_WAYLAND=1 obsidian -enable-features=UseOzonePlatform -ozone-platform=wayland";
      };
      "1password" = { 
        name = "1Password";
        terminal = false;
        icon = "${pkgs._1password-gui}/share/1password/resources/icons/hicolor/256x256/apps/1password.png";
        exec = "1password -enable-features=UseOzonePlatform -ozone-platform=wayland";
      };
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
          modules-right = ["clock" "battery" "pulseaudio" "tray" ];

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
  };
}