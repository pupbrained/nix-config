{
  description = "Marshall's NixOS Config";

  inputs = {
    draconis.url = "github:marsupialgutz/draconis";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs.url = "github:marsupialgutz/nixpkgs-nvidia-open";
    nixvim.url = "github:pta2002/nixvim";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nur.url = "github:nix-community/NUR";
    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
    vscodeInsiders.url = "github:cideM/visual-studio-code-insiders-nix";

    catppuccin = {
      url = "github:catppuccin/discord";
      flake = false;
    };

    essence-theme = {
      url = "github:discord-extensions/essence";
      flake = false;
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    horizontal-server-list = {
      url = "github:DiscordStyles/HorizontalServerList";
      flake = false;
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    powercord-tiktok-tts = {
      url = "github:oatmealine/powercord-tiktok-tts";
      flake = false;
    };

    theme-toggler = {
      url = "github:redstonekasi/theme-toggler";
      flake = false;
    };

    web-greeter = {
      type = "git";
      url = "https://github.com/JezerM/web-greeter";
      submodules = true;
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
    hyprland,
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
          hyprland.nixosModules.default
          {programs.hyprland.enable = true;}
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
