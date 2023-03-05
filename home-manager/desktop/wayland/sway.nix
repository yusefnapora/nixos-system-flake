{ config, nixosConfig, lib, pkgs, inputs, ... }:
let
  inherit (lib) mkIf;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.lists) optionals;
  inherit (lib.strings) optionalString;

  cfg = nixosConfig.yusef.sway;

  cursor-size = 24;
  
  background-image = (builtins.path { name = "jwst-carina.jpg"; path = ../backgrounds/jwst-carina.jpg; });
  lock-cmd = "${pkgs.swaylock-effects}/bin/swaylock -S --daemonize";

  nvidia-env-vars = optionalString cfg.nvidia ''
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __GL_GSYNC_ALLOWED=0
    export __GL_VRR_ALLOWED=0
    export WLR_DRM_NO_ATOMIC=1
  '';

  # fix for invisible cursor when running in vmware or nvida gpus
  hardwareCursorsFix = optionalString cfg.no-hardware-cursors-fix ''
    export WLR_NO_HARDWARE_CURSORS=1
  '';

  sway-cmd = if cfg.nvidia then "sway --unsupported-gpu" else "sway";

  start-sway = pkgs.writeShellScriptBin "start-sway" ''
    ${nvidia-env-vars}
    ${hardwareCursorsFix}
    exec ${pkgs.dbus}/bin/dbus-run-session ${sway-cmd}
  '';

  swaymonad = inputs.swaymonad.defaultPackage.${pkgs.system};
  restart-swaymonad = pkgs.writeShellScriptBin "restart-swaymonad" ''
    pkill -f 'python3 .+/swaymonad'
    ${swaymonad}/bin/swaymonad
  '';
in {
  imports = [ ./waybar ];

  config = mkIf (cfg.enable) {

    programs.fish.loginShellInit = ''
      # if running from tty1, start sway
      set TTY1 (tty)
      
      if [ "$TTY1" = "/dev/tty1" ]
        exec start-sway 
      end
    '';

    home.packages = builtins.attrValues {
      inherit (pkgs) wl-clipboard;
    } 
    ++ [ start-sway ]
    ++ optionals cfg.swaymonad [
      swaymonad
    ];

    # add pbcopy & pbpaste aliases for clipboard
    programs.fish.shellAliases = {
      pbcopy = "${pkgs.wl-clipboard}/bin/wl-copy";
      pbpaste = "${pkgs.wl-clipboard}/bin/wl-paste";
    };

    wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;

        config = { 
          modifier = "Mod4";
          terminal = cfg.terminal;
          output = cfg.output;
          window.hideEdgeBorders = "both";

          input."type:pointer" = mkIf cfg.natural-scrolling { 
            natural_scroll = "enabled";
          };

          input."type:touchpad" = mkIf cfg.natural-scrolling { 
            natural_scroll = "enabled";
          };

          input."type:mouse" = mkIf cfg.natural-scrolling {
            natural_scroll = "enabled";
          };

          keybindings = 
            let
              modifier = config.wayland.windowManager.sway.config.modifier;
            in lib.mkOptionDefault ({
              "${modifier}+space" = "exec ${pkgs.albert}/bin/albert show";
              "${modifier}+Shift+slash" = "exec ${lock-cmd}";
            } // optionalAttrs cfg.swaymonad {
              "${modifier}+j" = "nop focus_next_window";
              "${modifier}+k" = "nop focus_prev_window";
              "${modifier}+Shift+Left" = "nop move left";
              "${modifier}+Shift+Down" = "nop move down";
              "${modifier}+Shift+Up" = "nop move up";
              "${modifier}+Shift+Right" = "nop move right";
              "${modifier}+Shift+j" = "nop swap_with_next_window";
              "${modifier}+Shift+k" = "nop swap_with_prev_window";
              "${modifier}+x" = "nop reflectx";
              "${modifier}+y" = "nop reflecty";
              "${modifier}+t" = "nop transpose";
              "${modifier}+f" = "nop fullscreen";
              "${modifier}+Comma" = "nop increment_masters";
              "${modifier}+Period" = "nop decrement_masters";
              "${modifier}+l" = "mode \"layout\"";
            });

          modes = lib.mkOptionDefault (optionalAttrs cfg.swaymonad {
            layout = {
              "t" = "nop set_layout tall";
              "3" = "nop set_layout 3_col";
              "n" = "nop set_layout nop";
              "Return" = "mode \"default\"";
              "Escape" = "mode \"default\"";
            };
          });


          focus.wrapping = "no";

          startup = [
            { command = "${pkgs.albert}/bin/albert"; }
            { command = ''
                ${pkgs.swayidle}/bin/swayidle -w \
                  timeout ${builtins.toString cfg.lock-timeout} '${lock-cmd}' \
                  timeout ${builtins.toString cfg.suspend-timeout} 'sudo systemctl suspend' \
                  before-sleep '${lock-cmd}' \
                  lock '${lock-cmd}'
              ''; 
            }
          ] 
          ++ cfg.startup-commands
          ++ optionals cfg.swaymonad [
            { command = "${restart-swaymonad}/bin/restart-swaymonad"; always = true; }
          ];

          bars = [
            {
              command = "waybar";
            }
          ];

          # set cursor size
          seat."*".xcursor_theme = "Vanilla-DMZ ${builtins.toString cursor-size}";
        };

        extraConfig = ''
          # announce a running sway session to systemd
          exec systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP
          exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
        '';

        extraSessionCommands = ''
          export QT_AUTO_SCREN_SCALING_FACTOR=1 
          export QT_QPA_PLATFORM=wayland
          export QT_WAYLAND_DISABLE_WINDOW_DECORATIONS=1
          export GDK_BACKEND=wayland
          export MOZ_ENABLE_WAYLAND=1
          export XDG_SESSION_TYPE=wayland
          export XDG_SESSION_DESKTOP=sway
          export XDG_CURRENT_DESKTOP=sway
          export _JAVA_AWT_WM_NONREPARENTING=1
        '';
    };

    
    # xsettingsd is needed to set the cursor size for XWayland apps
    services.xsettingsd.enable = true;

    # more cursor config
    home.pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = cursor-size;
      gtk.enable = true;
    };

    # start electron apps in native wayland mode
    # see: https://github.com/microsoft/vscode/issues/136390#issuecomment-1340891893
    programs.fish.shellAliases = {
      code = "code --enable-features=WaylandWindowDecorations --ozone-platform=wayland";
      obsidian = "OBSIDIAN_USE_WAYLAND=1 obsidian -enable-features=UseOzonePlatform -ozone-platform=wayland";
      chromium = "chromium --ozone-platform=wayland";

      # leave 1password in Xwayland mode, since the clipboard is broken in wayland:
      # https://1password.community/discussion/121681/copy-passwords-under-pure-wayland
      # "1password" = "1password -enable-features=UseOzonePlatform -ozone-platform=wayland";
    };

    # apply wayland mode hacks to desktop entries for electron apps
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

      chromium-browser = {
        name = "Chromium";
        terminal = false;
        icon = "${pkgs.chromium}/share/icons/hicolor/256x256/apps/chromium.png";
        exec = "chromium --ozone-platform=wayland";
      };
      
      # use xwayland until clipboard bug is fixed: 
      # https://1password.community/discussion/121681/copy-passwords-under-pure-wayland 
      # "1password" = { 
      #   name = "1Password";
      #   terminal = false;
      #   icon = "${pkgs._1password-gui}/share/1password/resources/icons/hicolor/256x256/apps/1password.png";
      #   exec = "1password -enable-features=UseOzonePlatform -ozone-platform=wayland";
      # };   
    };

  };
}
