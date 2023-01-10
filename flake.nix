{
  inputs = { 
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = { 
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server = {
      url = "github:msteen/nixos-vscode-server"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";    
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, vscode-server, agenix, nix-darwin, ... }: 
  let
    inherit (nixpkgs.lib) nixosSystem lists;
    inherit (nix-darwin.lib) darwinSystem;

    mkSystemConfig = { 
      system, 
      modules, 
      useHomeManager ? true, 
      ... 
    }: nixosSystem { 
        inherit system;
        specialArgs = inputs;

        modules = modules
          ++ [ vscode-server.nixosModule
               ({ config, pkgs, ... }: {
                 services.vscode-server.enable = true;
               })

               agenix.nixosModule
             ] 
          ++ lists.optionals (useHomeManager) [
              home-manager.nixosModules.home-manager {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.users.yusef = {
                  imports = [
                    ./home-manager
                  ];
                };

                home-manager.extraSpecialArgs = {
                  inherit system inputs;
                  darwinConfig = {};
                };
              }
      
            ];
      };


  in
  {
    ### --- nixos configs
    nixosConfigurations = {
      # macbook via UTM virtual machine (TODO: change hostname)
      nixos = mkSystemConfig {
        system = "aarch64-linux";
        modules = [
          ./system/hosts/macbook-vm.nix
        ];
      };

      # macbook via Parallels VM
      parallels = mkSystemConfig { 
        system = "aarch64-linux";
        modules = [
          ./system/hosts/parallels-guest.nix
        ];
      };

      # VMWare guest (windows 11 host)
      virtualboy = mkSystemConfig { 
        system = "x86_64-linux";
        modules = [
          ./system/hosts/vmware-guest.nix
        ];
      };

      # WSL2 on Win11
      Hex = mkSystemConfig {
        system = "x86_64-linux";
        modules = [
          ./system/hosts/hex-wsl.nix
        ];
      };

      # Intel NUC (11th gen)
      musicbox = mkSystemConfig {
        system = "x86_64-linux";
        modules = [ ./system/hosts/musicbox.nix ];
      };

    };

    ### --- nix-darwin configs
    darwinConfigurations = {
      sef-macbook = darwinSystem {
        system = "aarch64-darwin";
        modules = [ 
          ./darwin/hosts/macbook.nix 
          
          home-manager.darwinModules.home-manager {
                home-manager.useGlobalPkgs = true;
                # home-manager.useUserPackages = true;

                home-manager.users.yusef = {
                  imports = [
                    ./home-manager
                  ];
                };

                home-manager.extraSpecialArgs = {
                  inherit inputs;
                  nixosConfig = {};
                  system = "aarch64-darwin";
                };
              }
          ];
        inputs = { inherit nix-darwin home-manager nixpkgs; };
      };
    };
  };
}
