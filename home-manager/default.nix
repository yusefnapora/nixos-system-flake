{ config, system, pkgs, nixpkgs, lib, nixosConfig ? {}, darwinConfig ? {}, ... }:
let
  inherit (lib) lists mkIf;

  systemConfig = nixosConfig // darwinConfig;
  isX86 = lib.strings.hasPrefix "x86_64" system;
  isDarwin = lib.strings.hasSuffix "darwin" system;
  isLinux = !isDarwin;

  withGUI = systemConfig.yusef.gui.enable;

  packages = builtins.attrValues {
    inherit (pkgs)
      nixFlakes
      jq
      tealdeer
      unzip
      deno
      nushell
      fossil
      sqlite
      htop
      killall
      tree
      lnav
      duf
      ripgrep
      fd
      atool
      bat
      gron
      ;
  };

  guiPackages = builtins.attrValues {
    inherit (pkgs) kitty;
  }
  ++ lists.optionals isLinux (builtins.attrValues {
    inherit (pkgs)
      dmenu
      firefox
      chromium
      zeal
      tigervnc
      obsidian
      _1password-gui
      vlc
      mpv
      ;
  })
  ++ lists.optionals (isX86 && isLinux) (builtins.attrValues {
    inherit (pkgs)
      calibre
      zoom-us
      slack
      logseq
      simplescreenrecorder
      ;
    inherit (pkgs.jetbrains) idea-ultimate;
  });
in
{
  imports = [
    ./git.nix
    ./fish.nix
    ./vscode.nix
    ./helix.nix
    ./tmux.nix
    ./nvim
  ] ++ lists.optionals isLinux [
    ./alacritty.nix
    ./i3.nix
    ./sway.nix
    ./polybar.nix
    ./rofi
    ./npm.nix
    ./obs.nix
    ./ssh.nix
  ];

  nixpkgs.config = import ./nixpkgs-config.nix;
  home.file."nixpkgs-config" = {
    target = ".config/nixpkgs/config.nix";
    source = ./nixpkgs-config.nix;
  };

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  
    nix-index = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  # set firefox as default browser (chromium hijacks it by default)
  xdg = mkIf (withGUI && isLinux) {
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
      };
    };
  };

  home = {
    stateVersion = "21.11";
    packages = packages ++ lists.optionals (withGUI) guiPackages;
    sessionVariables = {
      EDITOR = "hx";
      COLORTERM = "truecolor";
    };
  };
}
