{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  # boot.loader.grub = {
  #   efiSupport = true;
  #   efiInstallAsRemovable = true;
  #   device = "nodev";
  # };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/628A-7F3B"; fsType = "vfat"; };
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };
  
}
