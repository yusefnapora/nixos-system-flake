{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule {
  name = "obs-cli";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "obs-cli";
    rev = "v0.5.0";
    sha256 = "sha256-4tjS+PWyP/T0zs4IGE6VQ5c+3tuqxlBwfpPBVEcim6c=";
  };

  vendorHash = "sha256-RGpkqX97zalZv4aDfihJBKO1l2O8tcxn0I1SPL1WIg8=";
}