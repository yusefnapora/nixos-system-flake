{ config, system, nixosConfig, pkgs, nixpkgs, lib, ... }:
let
  inherit (lib) lists mkIf;

  withGUI = nixosConfig.yusef.gui.enable;

  isX86 = system == "x86_64-linux";

  packages = with pkgs; [
    nixFlakes
    jq
    cht-sh
    unzip
    deno
    nushell
    helix
  ];

  guiPackages = with pkgs; [
    kitty
    alacritty
    dmenu
    firefox
    chromium
    zeal
    tigervnc
    obsidian
  ] ++ lists.optionals (isX86) [
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
    ./i3.nix
    ./polybar.nix
    ./fish.nix
    ./vscode.nix
    ./kitty.nix
    ./rofi
    ./obs.nix
    ./npm.nix
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
  
    ssh = {
      enable = true;
      extraConfig = ''
        AddKeysToAgent=yes
      '';
    };
  };

  # set firefox as default browser (chromium hijacks it by default)
  xdg = mkIf withGUI {
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
  };
}
