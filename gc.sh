#!/usr/bin/env bash
set -e

if [ "$1" = "" ]; then
  echo "removing generations older than 5 days"
  generations="5d"
else
  generations=$1
fi

nix-env --delete-generations $generations
nix-store --gc