{ lib
, pkgs
,... }:
pkgs.stdenvNoCC.mkDerivation {
  name = "feather-icons-font";
  dontConfigure = true;
  src = pkgs.fetchFromGitHub {
    owner = "feathericon";
    repo = "feathericon";
    rev = "v1.0.2";
    sha256 = "sha256-BbQ65/5o1sXlTYH1VhjyNmQnG7Ib9EKk9VsOmTeMSU8=";
  };

  installPhase = ''
  mkdir -p $out/share/fonts/truetype
  cp $src/docs/fonts/feathericon.ttf $out/share/fonts/truetype/
  '';
}