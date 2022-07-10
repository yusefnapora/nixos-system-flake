{ pkgs, ... }:

let
    pkgName = "lgtv";
    pkgBuildInputs = with pkgs; [ bash websocat coreutils gnugrep ];
    src = pkgs.fetchFromGitHub {
      owner = "SaschaWessel";
      repo = "lgtv";
      rev = "000e902861ffd0a90849036481d7f92a6d67e48e";
      sha256 = "sha256-f1sGD0HR0ZzAS20VS4c2CSWXCs5W5TT0TGRzsrNrasc=";
    };
in
pkgs.symlinkJoin {
        name = pkgName;
        paths = [ src ] ++ pkgBuildInputs;
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
        cp $out/${pkgName} $out/bin/${pkgName}
        wrapProgram $out/bin/${pkgName} --set PATH $out/bin
        '';
}