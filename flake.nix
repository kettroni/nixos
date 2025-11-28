{
  description = "Nixos config flake";

  nixConfig = {
    # Use 'extra-substituters' to ADD to the default caches (like cache.nixos.org)
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];

    # Use 'extra-trusted-public-keys' to ADD the public key
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
    };

    kmonad = {
      url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, kmonad, ... }@inputs: {
    nixosConfigurations = {

      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/laptop/configuration.nix
          inputs.home-manager.nixosModules.default
          kmonad.nixosModules.default
        ];
      };

      desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktop/configuration.nix
          inputs.home-manager.nixosModules.default
          kmonad.nixosModules.default
        ];
      };

    };
  };
}
