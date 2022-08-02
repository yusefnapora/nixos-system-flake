{ pkgs, lib, ...}:
{
  material-icons = (pkgs.callPackage ./material-icons {});
  feather-icons = (pkgs.callPackage ./feather-icons {});
}