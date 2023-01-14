{ pkgs, lib, config, ...}:
let
  cfg = config.yusef.intel-sr-iov-kernel;
in {
  options.yusef.intel-sr-iov-kernel = {
    enable = lib.mkEnableOption "Build kernel with (experimental) support for SR-IOV virtualization for intel GPUs";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelPackages = let
        linux_sr_iov_pkg = { fetchFromGitHub, buildLinux, ... } @ args:

          buildLinux (args // rec {
            version = "5.15.71";
            modDirVersion = version;

            src = fetchFromGitHub {
              owner = "intel";
              repo = "linux-intel-lts";
              rev = "0a147290ae72ebbeee40d60f97c0748a550f5cd2"; # tip of branch: 5.15/linux as of 2023-01-11
              sha256 = "sha256-dIFX2JSBch1gMtb1fFp29JKAwhEU5og58hTt7mNDWGQ=";
            };
            kernelPatches = [];

            structuredExtraConfig = with pkgs.lib.kernel; {
              PCI_IOV = yes;
            };

            extraMeta.branch = "5.15";
          } // (args.argsOverride or {}));
        linux_sr_iov = pkgs.callPackage linux_sr_iov_pkg{};
      in 
        pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_sr_iov);

    # hack script with hardcoded device ids to enable vf's on boot
    # systemd.services.enable-vfs = {
    #   script = ''
    #     echo 2 > /sys/kernel/iommu_groups/1/devices/0000:00:02.0/sriov_numvfs
    #   '';

    #   wantedBy = [ "multi-user.target" ];

    #   serviceConfig = {
    #     Type = "oneshot";
    #     User = "root";
    #   };
    # };
  };
}