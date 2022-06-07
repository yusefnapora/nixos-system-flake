{ config, lib, pkgs, ...}:
let
  mod = "Mod4";
in
{
    xsession.windowManager.i3 = {
        enable = true;
        config = {
            modifier = mod;

            keybindings = lib.mkOptionalDefault {
                "${mod}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";
                "${mod}+Return" = "exec kitty";
            };
        };
    };
}