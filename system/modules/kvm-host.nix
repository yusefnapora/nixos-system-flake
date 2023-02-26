{ pkgs, lib, config, ...}:
let
  cfg = config.yusef.kvm-host;
in {
  options.yusef.kvm-host = {
    enable = lib.mkEnableOption "Enable libvirt / KVM virtual machine host config";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.virt-manager pkgs.spice-gtk ];
    
    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd.enable = true;
      libvirtd.qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;

        # enable TPM support (for win11)
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMFFull.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };

  };
}
