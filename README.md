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

## Things that might be interesting / useful to other people

There are a few things I've cobbled together that might be useful to others. I'm not a nix wizard, so no promises or anything :)

- 1Password aarch64 beta
  - very lightly modified version of the x86 definition in nixpkgs. It's probably better to override things on the official package, but this seems to work.
  - defined in [system/packages/1password-beta-aarch64.nix](./system/packages/1password-beta-aarch64.nix)

- Dual function Caps Lock with interception-tools
  - maps Caps Lock to Control when held, Esc when tapped
  - works in tty / console and X11 / Wayland
  - see [system/modules/key-remap.nix](./system/modules/key-remap.nix)
    - also has an option to swap left super and alt. There are simpler ways to do this with interception-tools, but I was already using the dual-function-keys plugin, and this seems to work.

- Installing random fonts (not from nixpkgs)
  - see [system/packages/fonts/feather-icons.nix](system/packages/fonts/feather-icons.nix) and [system/packages/fonts/material-icons.nix](system/packages/fonts/material-icons.nix).
  - basically, you just grab the font files from somewhere and use them as the `src` attribute in a call to `pkgs.stdEnvNoCC.mkDerivation`.
  - in the `installPhase`, copy fonts from `$src` to `$out/share/fonts/truetype` or `$out/share/fonts/opentype`, depending on the file type.

- Elgato Streamdeck configuration
  - if `config.yusef.streamdeck.enable = true`
    - installs the [streamdeck-ui](https://timothycrosley.github.io/streamdeck-ui/) project from nixpkgs (currently unstable only)
    - has [a thing](./system/programs/streamdeck/settings.nix) to define your button layout as a nix expression and write out a streamdeck-ui JSON config file. This gets written to `/etc/streamdeck_ui.json` and copied to `~/.streamdeck_ui.json` when i3 starts. I initally tried symlinking it, but the streamdeck-ui app gets mad if it can't write to the JSON file itself.
    - see [system/programs/streamdeck/my-config.nix](./system/programs/streamdeck/my-config.nix) for my current layout.
  - Why tho?
    - although it's a bit odd to use a GUI for the streamdeck only to then ignore all the GUI bits, I like being able to preview a config in the GUI and then "bake it in" to my nix config.
    - also, I like being able to write [little scripts for activating windows and stuff](./system/programs/streamdeck/scripts/) that depend on things in nixpkgs. Defining the config as a nix expression lets me easily refer to packages by their absolute path instead of depending on them being in the global `$PATH`.

- Silly USB switch / fake KVM thing
  - Okay, so...some background:
    - I use a 48" 4K TV made by LG as my main monitor
    - I have two PCs attached via HDMI (plus the occasional iPad, PlayStation, etc).
      - My main dev box is an Intel NUC (see [system/hosts/nux.nix](./system/hosts/nux.nix)). The other machine is a Windows PC.
    - I also have a USB switch that lets me switch my keyboard and mouse reciever dongles from one PC to another.
    - When I press the button on the USB switch, I need to fumble around for a second and find the remote control to switch TV inputs.
    - Wouldn't it be cool if pressing the button on the USB switch also switched the inputs on the TV?
  - My solution was to cobble together some scripts that live on the NUC to tell the TV to switch inputs, using a [thing I found on github](https://github.com/SaschaWessel/lgtv) to control the TV.
  - The scripts are triggered by `udev` events - when the USB dongle for my mouse is attached, we run the script that switches to the NUC's HDMI input. When the NUC sees the mouse dongle disconnect, we assume it's because I hit the button, and we switch HDMI inputs to the Windows machine.
  - Fun fact I discovered about `udev` triggers - they run in a super restricted sandbox, where you can't access the network & only have a few milliseconds to do anything. Luckily, it's really easy to define systemd services in NixOS, so I wrote oneshot wrapper services around the scripts. Now udev can just trigger the oneshot service, which doesn't have the sandbox limits.
  - If this sounds more fun than crazy to you, check out [system/modules/kvm-switch](./system/modules/kvm-switch) and see if there's anything worth stealing.
