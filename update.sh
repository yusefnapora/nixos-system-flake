#!/usr/bin/env bash

# this script updates the flake inputs, then pins the `nixpkgs` flake in the local registry
# to point to the same revision used to build the system. This makes `nix shell` a lot snappier,
# as it doesn't have to re-download nixpkgs, and we can share a lot of dependencies

nix flake update

# grab the current nixpkgs rev from the lockfile
nixpkgs_rev=$(jq -r '.nodes.nixpkgs.locked.rev' flake.lock)

# pin nixpkgs in the local flake registry
nix registry add nixpkgs "github:NixOS/nixpkgs/${nixpkgs_rev}"
