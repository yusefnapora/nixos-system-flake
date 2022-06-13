# nixos-system-flake

My [NixOS](https://nixos.org) configuration. 

It's still a work in progress, and if anyone stumbles across it and has ideas to make it better, please let me know with an issue or something.

## Usage

`./switch.sh` is a little wrapper around `sudo nixos-rebuild switch --flake`, defaulting to `.#` if you don't give it an argument.

## Organization

Subject to change, but I'm starting to kind of like it.

- [`system`](./system) has NixOS system configurations, most of which are slight variations on [`./system/default.nix`](./system/default.nix) for varios VM host / hardware environments.
  - [`system/hosts`](./system/hosts/) has NixOS configurations for specific hosts, with hardware definitions, etc.
  - [`system/modules`](./system/modules/) has a few modules for things like sound, remapping keys the way I like them, etc
  - [`system/programs`](./system/programs/) also has modules, but for specific programs you might want to enable & configure.
  - [`system/packages`](./system/packages/) has any custom packages we want to install.
  

- [`home-manager`](./home-manager/) has all home-manager configuration. Home manager options are currently set with a `homeManagerFlags` attr set that I'm stuffing into the `extraSpecialArgs` when adding the home-manager nixos module to the system config. This is kind of a hack, so hopefully I can come up with something better eventually.

