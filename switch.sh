#!/usr/bin/env bash

target=${1:-".#"}

exec sudo nixos-rebuild switch --flake $target

