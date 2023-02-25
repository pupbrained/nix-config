{
  description = "Marshall's NixOS Config";

  inputs = {
    agenix.url = "github:yaxitech/ragenix";
    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    doom-emacs.url = "github:nix-community/nix-doom-emacs";
    draconis.url = "github:pupbrained/draconis";
    flake-firefox-nightly.url = "github:colemickens/flake-firefox-nightly";
    glrnvim.url = "github:pupbrained/glrnvim-nix";
    home-manager.url = "github:nix-community/home-manager";
    neovim.url = "github:neovim/neovim?dir=contrib";
    nil.url = "github:oxalica/nil";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-init.url = "github:nix-community/nix-init";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:pta2002/nixvim";
    nix-snow.url = "github:pupbrained/nix-snow";
    nur.url = "github:nix-community/NUR";
    nurl.url = "github:nix-community/nurl";
    prism-launcher.url = "github:PrismLauncher/PrismLauncher";
    riff.url = "github:DeterminateSystems/riff";
    tre.url = "github:dduan/tre";
  };

  outputs = {
    agenix,
    darwin,
    fenix,
    home-manager,
    hyprland,
    neovim,
    nixos-wsl,
    nixpkgs,
    nixpkgs-old,
    nur,
    nurl,
    replugged,
    self,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    forSystems = lib.genAttrs lib.systems.flakeExposed;
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

    devShells = forSystems (
      system: let
        pkgs = nixpkgs.legacyPackages."${system}";
      in {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [nvfetcher agenix.packages.${system}.default git alejandra];
        };
        name = "dotfiles";
      }
    );

    formatter.${system} = pkgs.${system}.alejandra;
  };
}
