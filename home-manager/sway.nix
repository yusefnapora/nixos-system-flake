{ config, nixosConfig, lib, pkgs, ... }:
with lib;
let
  cfg = nixosConfig.yusef.sway;

  # fix for invisible cursor when running in vmware
  hardwareCursorsFix = strings.optionalString cfg.no-hardware-cursors-fix ''
    set -x WLR_NO_HARDWARE_CURSORS 1
  '';

  cursor-size = 24;
  
  background-image = (builtins.path { name = "jwst-carina.jpg"; path = ./backgrounds/jwst-carina.jpg; });
  lock-cmd = "${pkgs.swaylock}/bin/swaylock --daemonize --image ${background-image}";

  nvidia-env-vars = lib.strings.optionalString cfg.nvidia ''
    set -x GBM_BACKEND nvidia-drm
    set -x __GLX_VENDOR_LIBRARY_NAME nvidia
    set -x __GL_GSYNC_ALLOWED 0
    set -x __GL_VRR_ALLOWED 0
    set -x WLR_DRM_NO_ATOMIC 1
  '';

  sway-cmd = if cfg.nvidia then "sway --unsupported-gpu" else "sway";
in {
  imports = [ ./waybar ];

  config = mkIf (cfg.enable) {

    programs.fish.loginShellInit = ''
      # if running from tty1, start sway
      set TTY1 (tty)
      
      if [ "$TTY1" = "/dev/tty1" ]
        ${nvidia-env-vars}
        ${hardwareCursorsFix}
        exec ${pkgs.dbus}/bin/dbus-run-session ${sway-cmd}
      end
    '';

    home.packages = builtins.attrValues {
      inherit (pkgs) wl-clipboard;
    };

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
            in lib.mkOptionDefault {
              "${modifier}+space" = "exec ${pkgs.albert}/bin/albert show";
              "${modifier}+Shift+slash" = "exec ${lock-cmd}";
            };
          
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
          ] ++ cfg.startup-commands;

          bars = [
            {
              command = "waybar";
            }
          ];

          # set cursor size
          seat."*".xcursor_theme = "Vanilla-DMZ ${builtins.toString cursor-size}";
        };

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
