{
  description = "Personal NixOS-on-Asahi Configuration";

  nixConfig = {
    auto-optimise-store = true;
    builders-use-substitutes = true;
    extra-experimental-features = "nix-command flakes";
    flake-registry = "/etc/nix/registry.json";
    keep-derivations = true;
    keep-outputs = true;
    max-jobs = "auto";
    warn-dirty = false;

    daemonIOLowPriority = true;

    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://dram.cachix.org"
    ];

    trusted-substituters = ["cache.nixos.org" "nix-community.cachix.org" "dram.cachix.org"];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "dram.cachix.org-1:baoy1SXpwYdKbqdTbfKGTKauDDeDlHhUpC+QuuILEMY="
    ];

    trusted-users = ["marshall"];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    nix-dram.url = "github:dramforever/nix-dram";
    nix-software-center.url = "github:vlinkz/nix-software-center";
    nixvim.url = "github:pta2002/nixvim";
    nvfetcher.url = "github:berberman/nvfetcher";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    system = "aarch64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    name = "dotfiles";

    formatter.${system} = inputs.treefmt-nix.lib.mkWrapper pkgs {
      projectRootFile = "flake.nix";
      programs = {
        alejandra.enable = true;
        deadnix.enable = true;
        stylua.enable = true;
      };
    };

    nixosConfigurations = {
      canis-linux = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [./sys.nix];
      };
    };

    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        alejandra
        git
        inputs.nvfetcher.packages.${system}.default
        statix
      ];
    };
  };
}
