{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.yusef.kvm-switch;
  trigger-script = ((import ./udev-trigger.nix) { inherit pkgs; inherit lib; });
in
{
  options.yusef.kvm-switch = {
    enable = mkEnableOption "Enable rube-goldberg script to change monitor inputs and send WoL packet when USB KVM switch is triggered";

    trigger-device-product-string = mkOption {
      type = types.str;
      description = "PRODUCT string for usb trigger device (use `udevadm monitor --property` to find the right value)";
      default = "46d/c52b/1211"; # for logitech unifying receiver thing 
    };
  };

  config = mkIf cfg.enable {
    # Add udev rule to trigger script
    services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ENV{PRODUCT}=="${cfg.trigger-device-product-string}" RUN+="${pkgs.systemd}/bin/systemctl start yusef-kvm-add.service"
    ACTION=="remove", SUBSYSTEM=="usb", ENV{PRODUCT}=="${cfg.trigger-device-product-string}" RUN+="${pkgs.systemd}/bin/systemctl start yusef-kvm-remove.service"
    '';

    # add one-shot systemd services to actually do the stuff, since udev rules run in a limited sandbox (no network access, timeouts, etc)
    systemd.services.yusef-kvm-add = {
      enable = true;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${trigger-script}/bin/yusef-kvm-switch-udev-script add";
        StandardOutput = "journal";
      };
      wantedBy = ["multi-user.target"];
    };

    systemd.services.yusef-kvm-remove = {
      enable = true;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${trigger-script}/bin/yusef-kvm-switch-udev-script remove";
        StandardOutput = "journal";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}