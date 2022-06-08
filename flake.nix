{
  description = "Marshall's NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    nur.url = "github:nix-community/NUR";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-firefox-nightly.url = "github:colemickens/flake-firefox-nightly";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    vscodeInsiders.url = "github:cideM/visual-studio-code-insiders-nix";

    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
    theme-toggler = {
      url = "github:redstonekasi/theme-toggler";
      flake = false;
    };
    powercord-tiktok-tts = {
      url = "github:oatmealine/powercord-tiktok-tts";
      flake = false;
    };
    lavender-discord = {
      url = "github:Lavender-Discord/Lavender";
      flake = false;
    };
    catppuccin = {
      url = "github:catppuccin/discord";
      flake = false;
    };
    sur-cord = {
      url = "github:SlippingGitty/surCord";
      flake = false;
    };
    horizontal-server-list = {
      url = "github:DiscordStyles/HorizontalServerList";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixos-wsl
    , ...
    } @ inputs:
    let
      inherit (nixpkgs) lib;
    in
    {
      nixosConfigurations = {
        nix = lib.nixosSystem {
          system = "x86_64-linux";
          # Pass inputs to NixOS modules
          specialArgs = { inherit inputs; };
          modules = [
            ./sys/nix/configuration.nix
            home-manager.nixosModule
          ];
        };
        wsl = lib.nixosSystem {
          system = "x86_64-linux";
          # Pass inputs to NixOS modules
          specialArgs = { inherit inputs; };
          modules = [
            ./sys/wsl.nix
            nixos-wsl.nixosModules.wsl
            home-manager.nixosModule
          ];
        };
      };
    };
}
