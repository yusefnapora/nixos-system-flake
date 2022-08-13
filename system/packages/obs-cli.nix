{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule {
  name = "obs-cli";

  src = fetchFromGitHub {
    owner = "muesli"; # using my fork until upstream supports v5 protocol
    repo = "obs-cli";
    rev = "ed84a32dd2d93851349eb578ad08db3829453907";
    sha256 = "sha256-fd6FWjwLNfitWK3CYuba/OVN3iLRC51HZp+p1VR59cs=";
  };

  vendorHash = "sha256-KHkjAToGJhldqJi5qwjY7SaRh67TfPAwXNaKJMyutxE=";
}