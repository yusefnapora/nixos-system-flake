{ config, pkgs, lib, nixosConfig ? {}, darwinConfig ? {}, ...}:
let
  inherit (lib) mkOption types;
  inherit (pkgs) system;
in {
  options.yusef.system = with types; {
    config = mkOption {
      description = "Either the nixos or nix-darwin system configuration";
      type = types.attrs;
    };
  };

  config.yusef.system = {
    config = nixosConfig // darwinConfig;
  };
}
