# nixos-system-flake

My [NixOS](https://nixos.org) configuration. 

It's still a work in progress, and if anyone stumbles across it and has ideas to make it better, please let me know with an issue or something.

## Usage

`./switch.sh` is a little wrapper around `sudo nixos-rebuild switch --flake`, defaulting to `.#` if you don't give it an argument.

## Organization

Subject to change, but I'm starting to kind of like it.

- [`system`](./system) has NixOS system configurations, most of which are slight variations on [`./system/default.nix`](./system/default.nix) for various VM host / hardware environments.
  - [`system/hosts`](./system/hosts/) has NixOS configurations for specific hosts, with hardware definitions, etc.
  - [`system/modules`](./system/modules/) has a few modules for things like sound, remapping keys the way I like them, etc
  - [`system/programs`](./system/programs/) also has modules, but for specific programs you might want to enable & configure.
  - [`system/packages`](./system/packages/) has any custom packages we want to install.
  

- [`home-manager`](./home-manager/) has all home-manager configuration. All custom config options are defined in the nixos config, and are accessed using the `nixosConfig` variable that's passed in to home-manager modules when using the home-manager nixos module.

