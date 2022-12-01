#!/usr/bin/env bash
set -e


delete_kvm_ignore_file=0
if [ -f /tmp/yusef-kvm-ignore ]; then
  delete_kvm_ignore_file=0
fi

function cleanup() {
  if [ $delete_kvm_ignore_file != 0 ]; then
    rm -f /tmp/yusef-kvm-ignore
  fi
}
trap cleanup EXIT

if [ $(uname) = "Darwin" ]; then
  echo "building nix-darwin config"
  target_host=${1:-$(hostname | cut -d "." -f 1)}
  flake_target=".#darwinConfigurations.${target_host}.system"
  nix --extra-experimental-features 'nix-command flakes'  build ${flake_target}
  echo "switching to new config"
  ./result/sw/bin/darwin-rebuild switch --flake ".#${target_host}"
 exit
fi


target=${1:-".#"}

# tell our hacky kvm script to ignore events while we switch over
touch /tmp/yusef-kvm-ignore
delete_kvm_ignore_file=1

sudo nixos-rebuild switch --flake $target


