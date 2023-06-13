{ pkgs, lib, inputs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  imports = [
    ./common.nix
    ../options.nix
  ];

  system.stateVersion = 4;

  yusef.yabai = {
    enable = true;
    scriptingAdditions = true;
  };
}
