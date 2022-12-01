{ lib, ... }:
let
  inherit (lib) mkOption types;

in
{
  options.yusef = {
    gui.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Install & configure GUI apps";
    };

    fish = {
      init = lib.mkOption {
        type = types.lines;
        description = "added to fish initScript in home-manager config";
        default = "";
      };
    };
  };
}