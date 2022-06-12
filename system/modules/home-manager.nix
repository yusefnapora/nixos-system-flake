# WIP... thinking about going back to the home-manager nixos module, but using
# this to configure it and enable things conditionally

{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.yusef.home-manager;
in
{
    options.yusef.home-manager = {
        enable = mkEnableOption "Enable home-manager for user configuration";

        username = mkOption {
            type = types.str;
            description = "user to apply home-manager profile to";
            default = "yusef";
        };

        gui = mkOption {};
    };
}