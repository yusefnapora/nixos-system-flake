#!/usr/bin/env bash

target=${1:-".#"}

delete_kvm_ignore_file=1
if [ -f /tmp/yusef-kvm-ignore ]; then
  delete_kvm_ignore_file=0
fi

function cleanup() {
  if [ $delete_kvm_ignore_file != 0 ]; then
    rm -f /tmp/yusef-kvm-ignore
  fi
}
trap cleanup EXIT

# tell our hacky kvm script to ignore events while we switch over
touch /tmp/yusef-kvm-ignore

sudo nixos-rebuild switch --flake $target


