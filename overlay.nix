flake: final: prev:
let
  inherit (flake) inputs;
  inherit (prev) lib callPackage writeShellScript;
  inherit (flake.inputs) nix-option nixpkgs;
in
let
  cp = f: (callPackage f) {};
in {
    inherit flake;

    wrapWine = cp ./packages/wrapWine.nix;

    wineApps = {
      ade = cp ./packages/wineApps/adobe-digital-editions.nix;
    };
}