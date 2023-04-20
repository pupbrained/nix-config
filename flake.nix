{
  description = "Marshall's Nix-Darwin Config";

  inputs = {
    caligula.url = "github:ifd3f/caligula";
    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    deadnix.url = "github:astro/deadnix";
    fenix.url = "github:nix-community/fenix";
    home-manager.url = "github:nix-community/home-manager";
    nickel.url = "github:tweag/nickel";
    nil.url = "github:oxalica/nil";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-kitty-latest.url = "github:adamcstephens/nixpkgs/kitty/0.28.0";
    nixvim.url = "github:pta2002/nixvim";
    nurl.url = "github:nix-community/nurl";
  };

  outputs = {
    darwin,
    fenix,
    home-manager,
    nixpkgs,
    ...
  } @ inputs: let
    system = "aarch64-darwin";
    pkgs = import nixpkgs {inherit system;};
  in {
    name = "dotfiles";
    formatter.${system} = pkgs.${system}.alejandra;
    packages.${system}.default = fenix.packages.${system}.minimal.toolchain;

    darwinConfigurations.canis = darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [./sys.nix "${home-manager}/nix-darwin"];
    };

    devShells.${system}.default = pkgs.mkShellNoCC {packages = with pkgs; [alejandra git nvfetcher];};
  };
}
