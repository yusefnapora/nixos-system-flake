{ config, system, pkgs, nixpkgs, lib, nixosConfig ? {}, darwinConfig ? {}, ... }:
let
  inherit (lib) lists mkIf;

  systemConfig = nixosConfig // darwinConfig;
  isX86 = lib.strings.hasPrefix "x86_64" system;
  isDarwin = lib.strings.hasSuffix "darwin" system;
  isLinux = !isDarwin;

  withGUI = systemConfig.yusef.gui.enable;

  packages = with pkgs; [
    nixFlakes
    jq
    cht-sh
    unzip
    deno
    nushell
    fossil
    tmux
    sqlite
    htop
    killall
    tree
  ];

  guiPackages = with pkgs; [
    kitty
  ] 
  ++ lists.optionals isLinux [
    alacritty
    dmenu
    firefox
    chromium
    zeal
    tigervnc
    obsidian
  ]
  ++ lists.optionals (isX86 && isLinux) [
    calibre
    zoom-us
    slack
    logseq
    simplescreenrecorder
    jetbrains.idea-ultimate
  ];
in
{
  imports = [
    ./git.nix
    ./fish.nix
    ./vscode.nix
    ./helix.nix
  ] ++ lists.optionals isLinux [
    ./i3.nix
    ./polybar.nix
    ./rofi
    ./npm.nix
    ./obs.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "1password"
      "1password-cli"
      "vscode"
      "vscode-with-extensions"        
  ];

  programs = {
    home-manager.enable = true;

    direnv.enable = true;
    direnv.nix-direnv.enable = true;
  
    ssh = mkIf isLinux {
      enable = true;
      extraConfig = ''
        AddKeysToAgent=yes
      '';
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
      COLORTERM = "truecolor";
    };
  };
}
