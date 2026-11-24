{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lig = {
        url = "github:KevenGoncalves/lig";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
          url = "github:ryantm/agenix";
          inputs.nixpkgs.follows = "nixpkgs";
        };
    paneru = {
      url = "github:karinushka/paneru";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-darwin, home-manager, agenix, ... }:
  let
  makeDarwinHost = { hostname, username, system ? "aarch64-darwin", extraModules ? [] }:
  nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = { inherit self username; };
    modules = [
        ./hosts/macbook/configuration.nix
        { networking.hostName = hostname; }
        home-manager.darwinModules.home-manager {
          environment.systemPackages = [ agenix.packages.${system}.default ];

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs username; };
          home-manager.sharedModules = [ agenix.homeManagerModules.default ];
          home-manager.users.${username} = ./hosts/macbook/home.nix;
        }
      ] ++ extraModules;
    };
  in {
    darwinConfigurations = {
      macbook = makeDarwinHost {
        hostname = "macbook";
        username = "andreasfosshaug";
      };

      macmini = makeDarwinHost {
        hostname = "macmini";
        username = "andreasmacmini";
      };
    };

    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs self;};
          modules = [
            ./hosts/desktop/configuration.nix
            home-manager.nixosModules.home-manager
            {
              environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [ agenix.homeManagerModules.default ];
              home-manager.users.andreas = ./hosts/desktop/home.nix;
            }
          ];
        };

  };
}
