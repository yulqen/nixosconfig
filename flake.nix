{
    description = "My NixOS configuration";

    inputs = {
        nixneovim.url = "github:nixneovim/nixneovim";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    };

    outputs = { self, nixpkgs, home-manager, firefox-addons, nixneovim, ... }@inputs:

    let
        system = "x84-64-linux";
        user = "lemon";
        location = "$HOME/nixosconfig";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ nixneovim.overlays.default ];
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
                        home-manager.extraSpecialArgs = { inherit inputs; };
                        home-manager.useUserPackages = true;
                        home-manager.users.lemon = import ./core/laptop_home.nix;
                    }
                ];
            };
            nixos-220 = lib.nixosSystem {
                inherit system;
                modules = [ ./machines/x220/configuration.nix
                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.extraSpecialArgs = { inherit inputs; };
                        home-manager.useUserPackages = true;
                        home-manager.users.lemon = import ./core/laptop_home.nix;
                    }
                ];
            };

            nixos-x1 = lib.nixosSystem {
                inherit system;
                specialArgs = inputs;
                modules = [ ./machines/x1/configuration.nix
                            home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.extraSpecialArgs = { inherit inputs; };
                        home-manager.useUserPackages = true;
                        home-manager.users.lemon = import ./core/laptop_home.nix;
                    }
                ];
            };
        };
    };
}
