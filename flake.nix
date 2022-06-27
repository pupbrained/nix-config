{
  description = "Marshall's NixOS Config";

  inputs = {
    draconis.url = "github:marsupialgutz/draconis";
    flake-firefox-nightly.url = "github:colemickens/flake-firefox-nightly";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixvim.url = "github:pta2002/nixvim";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
    nur.url = "github:nix-community/NUR";
    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
    vscodeInsiders.url = "github:cideM/visual-studio-code-insiders-nix";

    catppuccin = {
      url = "github:catppuccin/discord";
      flake = false;
    };

    compact-settings = {
      url = "github:FayneAldan/CompactSettings";
      flake = false;
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/d059b9448a04100cdd231872254283dc278a4ea0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    horizontal-server-list = {
      url = "github:DiscordStyles/HorizontalServerList";
      flake = false;
    };

    lavender-discord = {
      url = "github:Lavender-Discord/Lavender";
      flake = false;
    };

    powercord-tiktok-tts = {
      url = "github:oatmealine/powercord-tiktok-tts";
      flake = false;
    };

    sur-cord = {
      url = "github:SlippingGitty/surCord";
      flake = false;
    };

    theme-toggler = {
      url = "github:redstonekasi/theme-toggler";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-wsl,
    nixvim,
    nix-doom-emacs,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    forSystems = lib.genAttrs lib.systems.flakeExposed;
  in {
    nixosConfigurations = {
      nix = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./sys/nix/configuration.nix
          home-manager.nixosModule
        ];
      };
      wsl = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./sys/wsl.nix
          nixos-wsl.nixosModules.wsl
          home-manager.nixosModule
        ];
      };
    };
    devShells = forSystems (
      system: let
        pkgs = nixpkgs.legacyPackages."${system}";
      in {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [nvfetcher];
        };
      }
    );
  };
}
