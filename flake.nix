{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = github:nix-community/NUR;
    theme-toggler = { url = "github:redstonekasi/theme-toggler"; flake = false; };
    powercord-tiktok-tts = { url = "github:oatmealine/powercord-tiktok-tts"; flake = false; };
    lavender-discord = { url = "github:Lavender-Discord/Lavender"; flake = false; };
    catppuccin = { url = "github:catppuccin/discord"; flake = false; };
  };

  outputs = { self, nixpkgs, home-manager, nur, powercord-overlay, theme-toggler, powercord-tiktok-tts, lavender-discord, catppuccin }:
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
                { nixpkgs.overlays = [ powercord-overlay.overlay nur.overlay ]; }
                ({ pkgs, ... }:
                  {
                    environment.systemPackages = [
                      pkgs.nur.repos.marsupialgutz.draconis
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
