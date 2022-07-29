{ config, lib, pkgs, ...}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.yusef.streamdeck;

in
{
  options.yusef.streamdeck = {
    enable = mkEnableOption "Enable streamdeck-ui for Elgato stream deck";
  };

  config = mkIf cfg.enable {
    programs.streamdeck-ui.enable = true;
    
    # environment.systemPackages = [
    #   streamdeck-ui
    # ];

    # # services.udev.extraRules = ''
    # SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0060", TAG+="uaccess"
    # SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0063", TAG+="uaccess"
    # SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006c", TAG+="uaccess"
    # SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="006d", TAG+="uaccess"
    # SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", ATTRS{idProduct}=="0080", TAG+="uaccess"
    # '';
  };
}