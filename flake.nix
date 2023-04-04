{
  inputs = { 
    # nixpkgs is currently pinned to a version that's compatible with
    # nixos-apple-silicon - later revs have issues with the GPU driver
    # that cause sway to run with software rendering.
    nixpkgs.url = "github:NixOS/nixpkgs/1603d11595a232205f03d46e635d919d1e1ec5b9";

    nur.url = "github:nix-community/nur";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

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
      url = "github:tpwrules/nixos-apple-silicon/release-2023-03-21";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    swaymonad = {
      url = "github:nicolasavru/swaymonad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
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

  mkDarwinConfig = {
   system,
   modules,
   ...
  }: darwinSystem { 
    inherit system;

    inputs = { inherit nix-darwin home-manager nixpkgs; };
    modules = modules 
    ++ [
      home-manager.darwinModules.home-manager {
	home-manager.useGlobalPkgs = true;
	# home-manager.useUserPackages = true;

	home-manager.users.yusef = {
	  imports = [
	    nixvim.homeManagerModules.nixvim
	    ./home-manager/darwin.nix
	  ];
	};

	home-manager.extraSpecialArgs = {
	  inherit inputs system;
	  nixosConfig = {};
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
      # Intel MBP for work (ShareFile)
      yusef-sharefile-macbook = mkDarwinConfig {
        system = "x86_64-darwin";
        modules = [
          ./darwin/hosts/work-macbook.nix
        ];
      };

      # Personal M1 Pro 14" MBP
      # TODO: convert to mkDarwinConfig
      sef-macbook = mkDarwinConfig {
        system = "aarch64-darwin";
        modules = [ 
          ./darwin/hosts/macbook.nix 
        ];
      };
    };
  };
}
