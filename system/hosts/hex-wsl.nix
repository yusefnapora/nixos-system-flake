{ lib, pkgs, config, modulesPath, nixos-wsl, ... }:
{
  imports = [
    nixos-wsl.nixosModules.wsl

    ../default.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "yusef";
    startMenuLaunchers = true;
    nativeSystemd = true;

    wslConf.interop.appendWindowsPath = false;

    # Enable native Docker support
    docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };

  yusef = {
    gui.enable = true;
    i3.enable = true;
        
    fish.init = ''
    # set DISPLAY to host IP:0 to use X410 instead of WSLg
    # motivation: X410 supports window snapping / fancy zones / komorebi, etc.
    # revisit if this is fixed: https://github.com/microsoft/wslg/issues/22
    # WSLg should be disabled (https://x410.dev/cookbook/wsl/disabling-wslg-or-using-it-together-with-x410)
    # unless you need it for wayland
    set -x DISPLAY (grep nameserver /etc/resolv.conf | sed 's/nameserver //'):0

    # prefer to use linux vscode from cli
    set -x DONT_PROMPT_WSL_INSTALL true
    '';
  };

  # enable gnome-keyring
  services.gnome = {
    gnome-keyring.enable = true;
  };

  programs.dconf.enable = true;
  security.pam.services.xdm.enableGnomeKeyring = true;

  programs.ssh.startAgent = true;

  networking.hostName = "Hex";

  system.stateVersion = lib.mkForce "22.05";

}
