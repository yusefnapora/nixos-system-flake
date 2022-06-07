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
    overlay = import ./overlay.nix;
    
    mkSystemConfig = { system, hostConfigModule, ... }: nixpkgs.lib.nixosSystem { 
      inherit system;
      specialArgs = attrs;

      modules = [ 
        { 
          nixpkgs = { 
            pkgs = import nixpkgs { 
              inherit system;
              overlays = [
                overlay
              ];

              config = {
                allowUnfree = true;
              };
            }; 
          }; 
        }

        hostConfigModule
        
        home-manager.nixosModules.home-manager { 
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.yusef = { 
            imports = [ ./home/home.nix ];
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
      system = "x86_64-linux";
      hostConfigModule = ./hosts/fusion/configuration.nix;
    };

  };
}
