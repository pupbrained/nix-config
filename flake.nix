{
  description = "Marshall's Nix-Darwin Config";

  nixConfig = {
    auto-optimise-store = true;
    builders-use-substitutes = true;
    extra-experimental-features = "nix-command flakes auto-allocate-uids";
    flake-registry = "/etc/nix/registry.json";
    keep-derivations = true;
    keep-outputs = true;
    max-jobs = "auto";
    warn-dirty = false;

    daemonIOLowPriority = true;
    daemonProcessType = "Adaptive";

    extra-substituters = ["https://cache.nixos.org" "https://nix-community.cachix.org"];

    extra-trusted-substituters = ["cache.nixos.org" "nix-community.cachix.org"];

    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    trusted-users = ["marshall"];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caligula.url = "github:ifd3f/caligula";
    deadnix.url = "github:astro/deadnix";
    neovim.url = "github:neovim/neovim?dir=contrib";
    nix-super.url = "github:privatevoid-net/nix-super";
    nurl.url = "github:nix-community/nurl";
    nvfetcher.url = "github:berberman/nvfetcher";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = {
    darwin,
    home-manager,
    nixpkgs,
    treefmt-nix,
    ...
  } @ inputs: let
    system = "aarch64-darwin";
    pkgs = import nixpkgs {inherit system;};
  in {
    name = "dotfiles";

    formatter.${system} = treefmt-nix.lib.mkWrapper pkgs {
      projectRootFile = "flake.nix";
      programs = {
        alejandra.enable = true;
        deadnix.enable = true;
        stylua.enable = true;
      };
    };

    darwinConfigurations.canis = darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [./sys.nix "${home-manager}/nix-darwin"];
    };

    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = with pkgs; [
        alejandra
        git
        nixd
        inputs.nvfetcher.packages.${system}.default
      ];
    };
  };
}
