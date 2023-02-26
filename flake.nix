{
  description = "Marshall's NixOS Config";

  inputs = {
    agenix.url = "github:yaxitech/ragenix";
    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    draconis.url = "github:pupbrained/draconis";
    home-manager.url = "github:nix-community/home-manager";
    neovim.url = "github:neovim/neovim?dir=contrib";
    nil.url = "github:oxalica/nil";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-init.url = "github:nix-community/nix-init";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:pta2002/nixvim";
    nix-snow.url = "github:pupbrained/nix-snow";
    nur.url = "github:nix-community/NUR";
    nurl.url = "github:nix-community/nurl";
  };

  outputs = {
    agenix,
    darwin,
    home-manager,
    neovim,
    nixpkgs,
    nur,
    nurl,
    self,
    ...
  } @ inputs: let
    system = "aarch64-darwin";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [(import ./pkgs inputs)];
    };
  in {
    darwinConfigurations = {
      MacBook-Air = darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./sys/configuration.nix
          "${home-manager}/nix-darwin"
        ];
      };
    };

    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = with pkgs; [nvfetcher agenix.packages.${system}.default git alejandra];
    };

    name = "dotfiles";

    formatter.${system} = pkgs.${system}.alejandra;
  };
}
