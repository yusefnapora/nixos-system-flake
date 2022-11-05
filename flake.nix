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
  };

  outputs = inputs@{ self, nixpkgs, home-manager, vscode-server, ... }: 
  let
    inherit (nixpkgs.lib) nixosSystem lists;
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
                };
              }
      
            ];
      };


  in
  {
    # macbook via UTM virtual machine
    nixosConfigurations.nixos = mkSystemConfig {
      system = "aarch64-linux";
      modules = [
        ./system/hosts/macbook-vm.nix
      ];
    };

    # macbook via Parallels VM
    nixosConfigurations.parallels = mkSystemConfig { 
      system = "aarch64-linux";
      modules = [
        ./system/hosts/parallels-guest.nix
      ];
    };

    # VMWare guest (windows 11 host)
    nixosConfigurations.virtualboy = mkSystemConfig { 
      system = "x86_64-linux";
      modules = [
        ./system/hosts/vmware-guest.nix
      ];
    };

    # WSL2 on Win11
    nixosConfigurations.Hex = mkSystemConfig {
      system = "x86_64-linux";
      modules = [
        ./system/hosts/hex-wsl.nix
      ];
    };

    # Intel NUC (11th gen)
    nixosConfigurations.nux = mkSystemConfig {
      system = "x86_64-linux";
      modules = [ ./system/hosts/nux.nix ];
    };
  };
}
