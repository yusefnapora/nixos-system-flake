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
    mkHomeManagerModule = { system, homeManagerFlags, ... }: 
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.yusef = import ./home-manager;

        home-manager.extraSpecialArgs = {
          inherit homeManagerFlags;
        };
      };

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
        specialArgs = attrs;

        modules = modules ++ nixpkgs.lib.lists.optionals (useHomeManager) [
          (mkHomeManagerModule { 
            inherit system homeManagerFlags;
          })
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

    # VMWare guest (windows 11 host)
    nixosConfigurations.virtualboy = mkSystemConfig { 
      system = "x86_64-linux";
      modules = [
        ./system/hosts/vmware-guest.nix
      ];
    };

  };
}
