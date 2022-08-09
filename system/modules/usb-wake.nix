{ pkgs, config, lib, ...}:
let
  inherit (lib) types mkIf mkOption;
  inherit (lib.lists) forEach count;
  inherit (lib.strings) concatStrings;

  device-spec = types.submodule {
    options = {
      vendor-id = mkOption { type = types.str; description = "USB vendor ID (the bit to the left of the colon in lsusb output)"; };
      product-id = mkOption { type = types.str; description = "USB product ID (the bit to the right of the colon in lsusb output)"; };
    };
  };

  cfg = config.yusef.usb-wake;
  enable = (count cfg.devices) != 0;

  actions = forEach cfg.devices (dev: 
    ''
    ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="${dev.vendor-id}" ATTRS{idProduct}=="${dev.product-id}" ATTR{power/wakeup}="enabled"
    ''
  );
in
{
  options.yusef.usb-wake = {
    devices = mkOption {
      type = types.listOf device-spec;
      description = "USB devices that should wake the system.";
      default = [];
    };
  };

  config = mkIf enable {
    services.udev.extraRules = concatStrings actions;
  };
}