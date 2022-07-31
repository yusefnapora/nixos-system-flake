{ lib, pkgs, config, ... }:
let
  scriptDeps = with pkgs; [ xdotool coreutils util-linux ];

  mkScriptPackage = name:
    let
      script = (pkgs.writeScriptBin name (builtins.readFile ./${name}))
        .overrideAttrs(old: {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
        });
    in pkgs.symlinkJoin {
      name = name;
      paths = [ script ] ++ scriptDeps;
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
      wrapProgram $out/bin/${name} --set PATH $out/bin
      '';
    };

in
{
  activate-window-by-name = mkScriptPackage "activate-window-by-name.sh";
  type-in-window = mkScriptPackage "type-in-window.sh"
}