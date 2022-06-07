final: prev: 
let
  p = path: prev.callPackage path {};
in
{
    wrapWine = p ./packages/wrapWine.nix;
    wineApps.ade = p ./packages/wineApps/adobe-digital-editions.nix;
}