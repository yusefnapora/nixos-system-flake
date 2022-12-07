{ lib, pkgs, ... }:
let
  oh-my-tmux = pkgs.fetchFromGitHub {
    owner = "gpakosz";
    repo = ".tmux";
    rev = "5641d3b3f5f9c353c58dfcba4c265df055a05b6b";
    sha256 = "sha256-BTeej1vzyYx068AnU8MjbQKS9veS2jOS+CaJazCtP6s=";

    # see https://github.com/NixOS/nixpkgs/issues/80109#issuecomment-1172953187  
    stripRoot = false;
  };
  tmux-conf = "${oh-my-tmux}/.tmux-${oh-my-tmux.rev}/.tmux.conf";
in
{
  home.file.tmux-conf = {
    target = ".tmux.conf";
    source = tmux-conf;
  };
}