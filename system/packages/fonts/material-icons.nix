{ lib
, pkgs
,... }:
pkgs.stdenvNoCC.mkDerivation {
  name = "material-icons-font";
  dontConfigure = true;
  src = pkgs.fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
    rev = "4.0.0";
    sha256 = "sha256-wX7UejIYUxXOnrH2WZYku9ljv4ZAlvgk8EEJJHOCCjE=";
  };

  installPhase = ''
  mkdir -p $out/share/fonts/{opentype,truetype}
  cp $src/font/*.otf $out/share/fonts/opentype/
  cp $src/font/*.ttf $out/share/fonts/truetype/
  '';
}