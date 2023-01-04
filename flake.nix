{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };    
  };

  outputs = { self, nixpkgs, home-manager }@inputs:

    let
      system = "x84-64-linux";
      user = "lemon";
      location = "$HOME/nixosconfig";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
      {
        nixosConfigurations = {
          nixos201 = lib.nixosSystem {
            inherit system;
            modules = [ ./machines/x201/configuration.nix
                        home-manager.nixosModules.home-manager
                        {
                          home-manager.useGlobalPkgs = true;
                          home-manager.useUserPackages = true;
                          home-manager.users.lemon = import ./machines/x201/home.nix;
                        }
                      ];
          };
          nixos-220 = lib.nixosSystem {
            inherit system;
            modules = [ ./machines/x220/configuration.nix
                        home-manager.nixosModules.home-manager
                        {
                          home-manager.useGlobalPkgs = true;
                          home-manager.useUserPackages = true;
                          home-manager.users.lemon = import ./machines/x220/home.nix;
                        }
                      ];
          };          
        };
      };
}
