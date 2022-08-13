{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule {
  name = "obs-cli";

  src = fetchFromGitHub {
    owner = "muesli"; # using my fork until upstream supports v5 protocol
    repo = "obs-cli";
    rev = "2980d83c681114d6f5d90c924626b92f0b937b6a";
    sha256 = "sha256-8hDJAaFH1LV03O3/uegbbWeuUPgP2ZoTxFvnEcTZEGs=";
  };

  vendorHash = "sha256-KHkjAToGJhldqJi5qwjY7SaRh67TfPAwXNaKJMyutxE=";
}