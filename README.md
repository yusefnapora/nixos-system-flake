# nixos-system-flake

My [NixOS](https://nixos.org) configuration. 

It's still a work in progress, and if anyone stumbles across it and has ideas to make it better, please let me know with an issue or something.

## Usage

I use [just](https://github.com/casey/just) to manage housekeeping tasks like building the config and switching to it.

When installing to a brand new machine without `just` in the path, you can run `nix shell nixpkgs#just` or `nix-shell -p just` to get it, then `just --list` to list the build tasks.

The most important are `just switch`, which rebuilds the config and switches to it, and `just update`, which updates flake inputs. If the build fails, try running `just trace`, which builds the config with the `--show-trace` flag set.

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

- Dual function Caps Lock with interception-tools
  - maps Caps Lock to Control when held, Esc when tapped
  - works in tty / console and X11 / Wayland
  - see [system/modules/key-remap.nix](./system/modules/key-remap.nix)
    - also has an option to swap left super and alt. There are simpler ways to do this with interception-tools, but I was already using the dual-function-keys plugin, and this seems to work.

- Allowing USB devices to wake the system
  - see [system/modules/usb-wake.nix](./system/modules/usb-wake.nix)
  - adds a `yusef.usb-wake.devices` option that takes a list of attrsets
    - e.g. `yusef.usb-wake.devices = [ { vendor-id = "abcd"; product-id = "1234"; } ]`
  - adds udev rules to set the `power/wakeup` attribute for each device to "enabled" (inspired by [this SO answer](https://unix.stackexchange.com/a/532839))

- Installing random fonts (not from nixpkgs)
  - see [system/packages/fonts/feather-icons](system/packages/fonts/feather-icons) and [system/packages/fonts/material-icons](system/packages/fonts/material-icons).
  - basically, you just grab the font files from somewhere and use them as the `src` attribute in a call to `pkgs.stdEnvNoCC.mkDerivation`.
  - I'm including the fonts I'm installing here in the repo, but you can also use e.g. `fetchFromGitHub` as the `src` to download them from elsewhere.
  - in the `installPhase`, copy fonts from `$src` to `$out/share/fonts/truetype` or `$out/share/fonts/opentype`, depending on the file type.

- Running certain comands as root without a `sudo` password
  - I run `nixos-rebuild` all the time, so it's nice to be able to run it with `sudo` without a password. Same for a few other things like `systemctl`, `reboot`, etc.
  - While this technically does give you the keys to the kingdom, my user account is also part of the `docker` group, which is just `root` with extra steps. 
  - As such, the point of a `sudo` password prompt is not to keep other people out, but to keep myself from accidentally destroying things by making me stop for a second before running scary commands.
  - see `security.sudo.extraRules` in [system/users/default.nix](./system/users/default.nix) for how to allow commands to run without a password. Note that you need to give an absolute path, so use e.g. `"${pkgs.systemd}/bin/systemctl"` instead of `"systemctl"`;

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

  - FWIW, this ridiculous hack is a perfect example of everything I love about NixOS. 
    - I can bang out a duct tape bash script solution to a silly problem that only I have.
    - So far, so good; I don't need Nix for that.
    - But what if I ever need to set this thing up again, or do it on another machine?
    - There are a lot of fiddly little moving parts here, like the fact that the `lgtv` control thing I found needs `websocat` installed, or that whole thing about needing to use a systemd service to make the udev trigger work.
    - In other words, to get my stupid 10 minute script to actualy work, I need a pretty precisely controlled environment, including a bunch of extra crap I didn't really plan for at the outset.
    - Setting up that environment _once_ is actually pretty fun and not really that hard, since you're doing it as you develop the solution in the first place.
    - But it's extra super not fun to come back in three years and have absolutely no idea what's going on, or where to find a version of `X` that's compatible with `Y` now that `Z` has been rewritten in rust or whatever.
    - Even if you take careful notes about all the dependencies and how to install everything, there's a decent chance that the world will change around you. 
      - In the immortal words of Abe Simpson, "I used to be with it. Then they changed what 'it' was, and now what I'm with isn't 'it,' and what's 'it' seems weird and scary to me. [It'll happen to you!](https://frinkiac.com/meme/S07E24/358040/m/SXQnbGwgaGFwcGVuIHRvIHlvdS4uLg==)"
    - With Nix, I can capture the dependencies for the `lgtv` thing, so it will always have `websocat` and I never need to think about it again or explicitly install it.
      - Think about it - how many times have you had to write something like this in a script:
        ```bash
        which jq || { echo "'jq' is not installed. Guess I'll just die then..."; exit 1 }
        ```
    - NixOS takes it a step further and lets me use things like systemd services and udev without worrying about whether I'll be able to remember how to copy all the config files to the right places or not if I ever do a clean re-install of my OS.
    - Anyway, that's probably enough ranting. I just think it's funny how much more likely I am to even start writing little hack scripts like this in the first place when I know I can "lock it down" and have a chance of it working again in a year or so.
