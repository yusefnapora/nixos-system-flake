

hostname := `hostname | cut -d "." -f 1`

# Build the nix-darwin system configuration without switching to it
[macos]
build target_host=hostname flags="":
  @echo "Building nix-darwin config..."
  nix --extra-experimental-features 'nix-command flakes'  build ".#darwinConfigurations.{{target_host}}.system" {{flags}}

# Build the nix-darwin configuration and switch to it
[macos]
switch target_host=hostname: (build target_host)
  @echo "switching to new config for {{target_host}}"
  ./result/sw/bin/darwin-rebuild switch --flake ".#{{target_host}}"


# on asahi linux, we need to pass the --impure flag to read in firmware files
rebuild_flags := `if [ -d /boot/asahi ]; then echo "--impure"; else echo ""; fi`

# Build the NixOS configuration without switching to it
[linux]
build target_host=hostname flags="":
	nixos-rebuild build .#{{target_host}} {{rebuild_flags}} {{flags}}

# Build the NixOS configuration and switch to it
[linux]
switch target_host=hostname:
  sudo nixos-rebuild switch .#{{target_host}} {{rebuild_flags}}

# Update flake inputs to their latest revisions and pin the local nixpkgs flake reference
update:
  nix flake update
  nix registry add nixpkgs "github:NixOS/nixpkgs/$(jq -r '.nodes.nixpkgs.locked.rev' flake.lock)"


# Garbage collect old OS generations and remove stale packages from the nix store
gc generations="5d":
  nix-env --delete-generations {{generations}}
  nix-store --gc
