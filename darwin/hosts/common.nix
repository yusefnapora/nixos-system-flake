{ pkgs, lib, inputs, ... }:
let
  inherit (inputs) nixpkgs;
in
{
  imports = [
    ../options.nix
    ../fonts.nix
  ];

  users.users.yusef = {
    name = "yusef";
    home = "/Users/yusef";
    shell = pkgs.fish;
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ 
    pkgs.vim
    pkgs.fish
    pkgs.rustup
  ];

  security.pam.enableSudoTouchIdAuth = true;

  programs.fish.enable = true;
  environment.shells = builtins.attrValues { inherit (pkgs) bashInteractive zsh fish; };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes repl-flake
  ''+ lib.optionalString (pkgs.system == "aarch64-darwin") ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # pin nixpkgs in the system flake registry to the revision used
  # to build the config
  nix.registry.nixpkgs.flake = nixpkgs;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.overlays = [
    (final: prev: lib.optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
      # Add access to x86 packages system is running Apple Silicon
      pkgs-x86 = import nixpkgs {
        system = "x86_64-darwin";
        config.allowUnfree = true;
      };
    }) 
  ];

  system.stateVersion = 4;
}
