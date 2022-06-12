{
  inputs = { 
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11"; 
    home-manager = { 
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@attrs: 
  let
    mkSystemConfig = { system, modules, ... }: nixpkgs.lib.nixosSystem { 
      inherit system modules;
      specialArgs = attrs;
    };
  in
  {

    # homeManagerConfigurations = {
    #   "yusef-x86-gui" = home-manager.lib.homeManagerConfiguration {
    #     configuration = ./home-manager/default.nix;
    #     system = "x86_64-linux";
    #     homeDirectory = "/home/yusef";
    #     username = "yusef";
    #     extraSpecialArgs = {
    #       inherit nixpkgs;

    #       featureFlags = {
    #         enableGUI = true;
    #         sound.enable = true;
    #       };
    #     };
    #   };

    # };

    # macbook via UTM virtual machine
    nixosConfigurations.nixos = mkSystemConfig {
      system = "aarch64-linux";
      modules = [
        ./system/hosts/macbook-vm.nix
      ];
    };

    # VMWare guest (windows 11 host)
    nixosConfigurations.fusion = mkSystemConfig { 
      system = "x86_64-linux";
      modules = [
        ./system/hosts/vmware-guest.nix
      ];
    };

  };
}
