{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.yusef._1password;
  targetSystem = config.yusef.system;

  _1password-package = if (targetSystem == "aarch64-linux") then
    pkgs.callPackage ../packages/1password-beta-aarch64.nix { }
   else
     pkgs._1password-gui;
in
{
  options.yusef._1password = {
    enable = mkEnableOption "Enable 1 Password";
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = [_1password-package];
  };
}
