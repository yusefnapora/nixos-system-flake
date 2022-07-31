{ lib, pkgs, ... }:
let
  scriptDeps = with pkgs; [ xdotool coreutils util-linux ];

  mkScriptPackage = name:
    let
      script = (pkgs.writeScriptBin name (builtins.readFile ./${name}))
        .overrideAttrs(old: {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
        });
        
      package = pkgs.symlinkJoin {
        name = name;
        paths = [ script ] ++ scriptDeps;
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
        wrapProgram $out/bin/${name} --prefix PATH $out/bin
        '';
      };
  in { 
    inherit package; 
    bin = "${package}/bin/${name}"; 
  };
in
{
  activate-window-by-name = (mkScriptPackage "activate-window-by-name.sh").bin;
  type-in-window = (mkScriptPackage "type-in-window.sh").bin;
}