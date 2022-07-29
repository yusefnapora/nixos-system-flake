{ pkgs, lib, ...}:
{
  material-icons = (pkgs.callPackage ./material-icons.nix {});
  feather-icons = (pkgs.callPackage ./feather-icons.nix {});
}