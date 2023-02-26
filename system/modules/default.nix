{ ... }:
{
    imports = [
        ./key-remap.nix
        ./sound.nix
        ./fonts.nix
        ./bluetooth.nix
        ./kvm-switch
        ./usb-wake.nix
        ./kvm-host.nix
        ./win-vm.nix
    ];
}
