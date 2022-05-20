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
    system = "aarch64-linux";

    homeConfig = home-manager.lib.homeManagerConfiguration { 
      system = system;
      homeDirectory = "/home/yusef";
      userName = "yusef";
      stateVersion = "21.11";
      configuration = { 
        imports = [ ./home.nix ];
      };
    };
  in
  {

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = attrs;
      modules =
        [ 
          ./configuration.nix
        ];
    };

  };
}
