# This file defines a nixpkgs overlay, so that we can refer to custom packages
# as pkgs.custom-package-name elsewhere in the config
# See system/programs/default for the bit where it gets added to nixpkgs

self: super: 
let
  p = path: (super.callPackage path {});
in
{
  yusef = {
    _1password-aarch64 = (p ./1password-beta-aarch64.nix);
    lgtv = (p ./lgtv.nix);
    trim-screencast = (p ./trim-screencast.nix);
    obs-cli = (p ./obs-cli.nix);
    fonts = (p ./fonts);
    wrapWine = (p ./wrapWine.nix);
    kindle = (p ./wineApps/kindle.nix);
  };
}