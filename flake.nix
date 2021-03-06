{
  inputs = { 
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; 
    home-manager = { 
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-vscode-server.url = "github:msteen/nixos-vscode-server";
    nixos-vscode-server.flake = false;
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: 
  let
    defaultHomeManagerFlags = {
      withGUI = true;
      withSway = true;
    };

    mkSystemConfig = { 
      system, 
      modules, 
      homeManagerFlags ? defaultHomeManagerFlags, 
      useHomeManager ? true, 
      ... 
    }: nixpkgs.lib.nixosSystem { 
        inherit system;
        specialArgs = inputs;

        modules = modules ++ nixpkgs.lib.lists.optionals (useHomeManager) [

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
              
              homeManagerFlags = homeManagerFlags // { 
                inherit system; 
              };
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


    # Intel NUC (11th gen)
    nixosConfigurations.nux = mkSystemConfig {
      system = "x86_64-linux";
      modules = [ ./system/hosts/nux.nix ];
    };
  };
}
