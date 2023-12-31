{
  description = "Your new nix config";

  inputs = {
    impermanence.url = "github:nix-community/impermanence";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nix-super.url = "github:privatevoid-net/nix-super";
    nvfetcher.url = "github:berberman/nvfetcher";
    rust-overlay.url = "github:oxalica/rust-overlay";
    thorium.url = "github:almahdi/nix-thorium/16cbc264b5e7baf09cb895e8c5a49f7d915399d8";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nixvim-config.url = "github:pupbrained/nixvim";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:pupbrained/nixvim-ocamllsp";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    formatter.${system} = inputs.treefmt-nix.lib.mkWrapper pkgs {
      projectRootFile = "flake.nix";
      programs = {
        alejandra.enable = true;
        deadnix.enable = true;
      };
    };

    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations.navis = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};

      modules = [./sys.nix];
    };

    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = with pkgs;
        [
          git
          statix
        ]
        ++ (with inputs; [
          nvfetcher.packages.${system}.default
        ]);
    };
  };
}
