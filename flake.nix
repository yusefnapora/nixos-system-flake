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

    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-ide = {
      url = "github:yusefnapora/nvim-ide?ref=fix-duplicate-help-tag";
      # url = "github:ldelossa/nvim-ide";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, vscode-server, agenix, nix-darwin, apple-silicon, nixvim, ... }: 
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

               agenix.nixosModules.default
             ] 
          ++ lists.optionals (useHomeManager) [
              home-manager.nixosModules.home-manager {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.users.yusef = {
                  imports = [
                    nixvim.homeManagerModules.nixvim
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

      # WSL2 on Win11
      Hex = mkSystemConfig {
        system = "x86_64-linux";
        modules = [
          ./system/hosts/hex-wsl.nix
        ];
      };

      # bare-metal on intel (dual boot to Hex windows install)
      nobby = mkSystemConfig {
        system = "x86_64-linux";
        modules = [
          ./system/hosts/nobby.nix
        ];
      };

      # Asahi on 14" M1 Macbook pro
      asahi = mkSystemConfig {
        system = "aarch64-linux";
        modules = [ ./system/hosts/asahi.nix ];
      };

      # NAS box
      nasty = mkSystemConfig {
        system = "x86_64-linux";
        modules = [ ./system/hosts/nasty.nix ];
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
