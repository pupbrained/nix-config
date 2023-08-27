{
  description = "Personal NixOS-on-Asahi Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvfetcher.url = "github:berberman/nvfetcher";

    treefmt-nix.url = "github:numtide/treefmt-nix";
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
