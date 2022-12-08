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

  home.file.tmux-conf-local = {
    target = ".tmux.conf.local";
    text = 
    ''
      # use Powerline symbols in status bar
      tmux_conf_theme_left_separator_main='\uE0B0'
      tmux_conf_theme_left_separator_sub='\uE0B1'
      tmux_conf_theme_right_separator_main='\uE0B2'
      tmux_conf_theme_right_separator_sub='\uE0B3'

      # customize status bar
      # removes uptime and battery info from default config
      tmux_conf_theme_status_left=" ❐ #S"
      tmux_conf_theme_status_right=" #{prefix}#{mouse}#{pairing}#{synchronized}, %R , %d %b | #{username}#{root} | #{hostname} "

      # copy mouse-mode selections to system clipboard
      tmux_conf_copy_to_os_clipboard=true

      # just use C-b as prefix instead of C-b and C-a
      set -gu prefix2
      unbind C-a
    '';
  };
}