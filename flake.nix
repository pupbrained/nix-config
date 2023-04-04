{
  description = "Marshall's Nix-Darwin Config";

  inputs = {
    agenix.url = "github:yaxitech/ragenix";
    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    draconis.url = "github:pupbrained/draconis";
    fenix.url = "github:nix-community/fenix";
    home-manager.url = "github:nix-community/home-manager";
    nickel.url = "github:tweag/nickel";
    nil.url = "github:oxalica/nil";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixvim.url = "github:pta2002/nixvim";
    nix-snow.url = "github:pupbrained/nix-snow";
    nurl.url = "github:nix-community/nurl";
  };

  outputs = {
    agenix,
    darwin,
    fenix,
    home-manager,
    nixpkgs,
    nurl,
    self,
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
      modules = [
        ./sys.nix
        "${home-manager}/nix-darwin"
      ];
    };

    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = with pkgs; [alejandra agenix.packages.${system}.default git nvfetcher];
    };
  };
}
