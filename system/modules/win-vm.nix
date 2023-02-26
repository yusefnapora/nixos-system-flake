{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types lists strings;
  inherit (lists) optionals;
  inherit (strings) concatStringsSep;
  inherit (lib.attrsets) optionalAttrs nameValuePair;

  cfg = config.yusef.win-vm;

  vfio-kernel-params = optionals (! (isNull cfg.vfio-pci-ids)) [
    "vfio-pci.ids=${concatStringsSep "," cfg.vfio-pci-ids}"
  ];

  kernel-params = cfg.iommu-params ++ vfio-kernel-params;
in {
  options.yusef.win-vm = with types; {
    enable = mkEnableOption "Enable Win11 VM with GPU & SSD passthrough";

    iommu-params = mkOption {
      description = "Kernel params to enable iommu. Defaults to params for intel CPUs";
      type = listOf str;
      default = [ "intel_iommu=on" "iommu=pt" ];
    };

    vfio-pci-ids = mkOption {
      description = "List of PCI vendor:device ids to bind to the vfio-pci driver at boot";
      type = nullOr (listOf str);
      default = null;
    };

    vfio-runtime-pci-devices = mkOption {
      description = ''
        List of PCI device paths to bind to the vfio-pci driver after boot. 
        Use if you have multiple devices with the same PCI vendor:device ids and
        don't want to bind all of them.
      '';
      type = nullOr (listOf str);
      default = null;
    };

    looking-glass = {
      enable = mkOption {
        type = bool;
        description = "Enable looking-glass shared framebuffer. Defaults to true";
        default = true;
      };

      framebuffer-size-mb = mkOption {
        description = "Size of looking-glass shared framebuffer in MB";
        type = int;
        default = 128; # enough for 4k.
      };

      user = mkOption {
        description = "User account to own the shared memory file.";
        type = str;
        default = "yusef";
      };

      group = mkOption {
        description = "Group to own the shared memory file.";
        type = str;
        default = "kvm";
      };
    };
  };

  config = mkIf cfg.enable {
  
    boot.kernelParams = kernel-params;
    boot.initrd.kernelModules = [
      "vfio"
      "vfio_pci"
    ] ++ optionals cfg.looking-glass.enable [
      "kvmfr"
    ];

    # Add systemd oneshot services for each PCI device to bind to the vfio-pci driver at runtime. 
    systemd.services = builtins.listToAttrs (lists.forEach cfg.vfio-runtime-pci-devices 
      (device-path: let
        service-name = "vfio-pci-${device-path}";
        script = pkgs.writeShellScript "${service-name}.sh" ''
          DEV="${device-path}"
          SYSDIR="/sys/bus/pci/devices/$DEV"
          VENDOR_ID=$(< "$SYSDIR/vendor")
          DEVICE_ID=$(< "$SYSDIR/device")

          if [ -L "$SYSDIR/driver" ]; then
            CURRENT_DRIVER=$(basename "$(readlink "$SYSDIR/driver")")
            if [ "$CURRENT_DRIVER" = "vfio-pci" ]; then
              echo "current driver for device $DEV is already vfio-pci, ignoring"
              exit 0
            fi
            echo "unbinding previous driver $CURRENT_DRIVER for device $DEV"
            if ! echo "$DEV" > "$SYSDIR/driver/unbind"; then
              echo "unbinding $DEV failed, exiting"
              exit 1
            fi
          fi

          echo "adding PCI device id (vendor: $VENDOR_ID, device: $DEVICE_ID) to vfio-pci driver"
          echo -n "$VENDOR_ID $DEVICE_ID" > "/sys/module/vfio_pci/drivers/pci:vfio-pci/new_id"

          echo "setting driver override for PCI device $DEV"
          echo "vfio-pci" > "$SYSDIR/driver_override"

          echo "re-probing driver for PCI device $DEV"
          echo "$DEV" > /sys/bus/pci/drivers_probe
        '';
      in 
      (nameValuePair service-name
        # service definition:
        {
          enable = true;
          wantedBy = [ "multi-user.target" ];
          after = [ "local-fs-pre.target" ]; # run before local filesystems are mounted
          description = "Bind the PCI device at ${device-path} to the vfio-pci driver";
          serviceConfig = {
            Type = "oneshot";
            ExecStart = script;
            StandardOutput = "journal";
          };
        }
      )
      )
    ); 

    environment.systemPackages = mkIf cfg.looking-glass.enable [ pkgs.looking-glass-client ];

    boot.extraModulePackages = mkIf cfg.looking-glass.enable [ config.boot.kernelPackages.kvmfr ];
    boot.extraModprobeConfig = mkIf cfg.looking-glass.enable ''
      options kvmfr static_size_mb=${builtins.toString cfg.looking-glass.framebuffer-size-mb}
    '';

    services.udev.extraRules = mkIf cfg.looking-glass.enable ''
      SUBSYSTEM=="kvmfr", OWNER="${cfg.looking-glass.user}", GROUP="${cfg.looking-glass.group}", MODE="0660"
    '';

    # tell looking-glass-client to use the shared mem device
    environment.etc."looking-glass-client.ini" = mkIf cfg.looking-glass.enable {
      inherit (cfg.looking-glass) user group;
      text = ''
        [app]
        shmFile=/dev/kvmfr0
      '';
    };

    # allow access to looking-glass SHM device
    # not sure if I actually need to include all the defaults, but can't hurt :)
    virtualisation.libvirtd.qemu.verbatimConfig = mkIf cfg.looking-glass.enable '' 
      cgroup_device_acl = [
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
        "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
        "/dev/kvmfr0"
      ]
    '';
  };
}
