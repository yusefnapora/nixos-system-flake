{ config, lib, pkgs, homeManagerFlags, ... }:
with lib;
let
  guiEnabled = homeManagerFlags.withGUI;

  extensions = (with pkgs.vscode-extensions; [
    bbenoist.nix
    ms-azuretools.vscode-docker
    ms-vscode-remote.remote-ssh
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    { # spacemacs color theme
      name = "spacemacs";
      publisher = "rkwan94";
      version = "0.0.2";
      sha256 = "094d4ae114bd3479014cd4517570cd446e4333e34bc859642a0d28ddefa06a7e";
    }
  ];
  
  defaultTheme = "spacemacs";
in
{
  config = mkIf (guiEnabled) {
    programs.vscode = {
      enable = true;

      inherit extensions;

      userSettings = {
        "workbench.colorTheme" = "Spacemacs";
      };
    };
  };
}