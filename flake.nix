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
    mkSystemConfig = { system, hostConfigModule, ... }: nixpkgs.lib.nixosSystem { 
      inherit system;
      specialArgs = attrs;
      modules = [ 
        hostConfigModule
        
        home-manager.nixosModules.home-manager { 
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.yusef = { 
            imports = [ ./home.nix ];
          };
        }
      ];
    };
  in
  {

    # macbook via UTM virtual machine
    nixosConfigurations.nixos = mkSystemConfig {
      system = "aarch64-linux";
      hostConfigModule = ./hosts/macbook-vm/configuration.nix;
    };

    # VMWare fusion guest (windows 11 host)
    nixosConfigurations.fusion = mkSystemConfig { 
      system = "x86_64";
      hostConfigModule = ./hosts/fusion/configuration.nix;
    };

  };
}
