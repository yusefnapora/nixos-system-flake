{ config, system, nixosConfig, pkgs, nixpkgs, lib, ... }:
with lib;
let
  withGUI = nixosConfig.yusef.gui.enable;
  withSway = nixosConfig.yusef.sway.enable;

  isX86 = system == "x86_64-linux";

  packages = with pkgs; [
    nixFlakes
    jq
  ];

  guiPackages = with pkgs; [
    kitty
    alacritty
    dmenu
  ] ++ lists.optionals (isX86) [
    zoom-us
    slack
    logseq
  ];
in
{
  imports = [
    ./git.nix
    ./sway.nix
    ./i3.nix
    ./polybar.nix
    ./fish.nix
    ./vscode.nix
    ./kitty.nix
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
  };

  home = {
    stateVersion = "21.11";
    packages = packages ++ lists.optionals (withGUI) guiPackages;
  };
}
