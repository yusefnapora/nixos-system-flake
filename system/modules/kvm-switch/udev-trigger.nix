{ pkgs, lib, ... }:

let
    pkgName = "yusef-kvm-switch-udev-script";
    pkgBuildInputs = with pkgs; [ yusef.lgtv wakeonlan coreutils util-linux ];
    script = (pkgs.writeScriptBin pkgName (builtins.readFile ./udev-trigger.sh)).overrideAttrs(old: {
        buildCommand = "${old.buildCommand}\n patchShebangs $out";
    });
in
pkgs.symlinkJoin {
        name = pkgName;
        paths = [ script ] ++ pkgBuildInputs;
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/${pkgName} --set PATH $out/bin
         '';
}