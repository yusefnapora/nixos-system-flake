{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (builtins) attrValues;
  inherit (lib.lists) optionals;

  inherit (pkgs.stdenv) isLinux isx86_64;
  gui-enabled = config.yusef.system.config.yusef.gui.enable;

  mkAsahiWrapper = (import ./asahi-wrapper.nix { inherit lib pkgs; });
  kitty = mkAsahiWrapper { name = "kitty"; package = pkgs.kitty; };

  common-packages = [ kitty ] 
    ++ attrValues {
      inherit (pkgs) treesheets;
    };

  linux-packages = attrValues {
    inherit (pkgs)
      dmenu
      chromium
      zeal
      tigervnc
      obsidian
      _1password-gui
      vlc
      mpv
      ;
    };

    x86-linux-packages = attrValues {
      inherit (pkgs)
        calibre
        zoom-us
        slack
        logseq
        simplescreenrecorder
        ;
    };
in {
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./obs.nix
    ./vscode.nix
  ];

  config = mkIf gui-enabled {
    home.packages =
      common-packages
      ++ optionals isLinux linux-packages
      ++ optionals (isLinux && isx86_64) x86-linux-packages;

    # set default browser to firefox
    xdg = mkIf isLinux {
      mime.enable = true;
      mimeApps.enable = true;
      mimeApps.defaultApplications = {
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
      };
    };
  };
}
