{
  description = "Marshall's NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    nur.url = github:nix-community/NUR;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-firefox-nightly.url = "github:colemickens/flake-firefox-nightly";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
    theme-toggler = { url = "github:redstonekasi/theme-toggler"; flake = false; };
    powercord-tiktok-tts = { url = "github:oatmealine/powercord-tiktok-tts"; flake = false; };
    lavender-discord = { url = "github:Lavender-Discord/Lavender"; flake = false; };
    catppuccin = { url = "github:catppuccin/discord"; flake = false; };
  };

  outputs = { self, nixpkgs, home-manager, nur, powercord-overlay, neovim-nightly-overlay, theme-toggler, powercord-tiktok-tts, lavender-discord, catppuccin, flake-firefox-nightly }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations =
        {
          nix = lib.nixosSystem
            {
              inherit system;
              modules = [
                ./sys/configuration.nix
                { nixpkgs.overlays = [ powercord-overlay.overlay nur.overlay neovim-nightly-overlay.overlay ]; }
                ({ pkgs, ... }:
                  {
                    environment.systemPackages = [
                      pkgs.nur.repos.marsupialgutz.draconis
                      flake-firefox-nightly.packages.x86_64-linux.firefox-nightly-bin
                      pkgs.zsh
                      pkgs.kitty
                      pkgs.discord-plugged
                      pkgs.neovim-nightly
                      (pkgs.discord-plugged.override
                        {
                          plugins = [
                            theme-toggler
                            powercord-tiktok-tts
                          ];
                          themes = [
                            lavender-discord
                            catppuccin
                          ];
                        })
                    ];
                  }
                )
              ];
            };
        };
      hmConfig = {
        marshall = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;
          username = "marshall";
          homeDirectory = "/home/marshall";
          stateVersion = "22.05";
          configuration = {
            imports = [
              ./home/home.nix
            ];
          };
        };
      };
    };
}
