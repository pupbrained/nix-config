{
  description = "Marshall's NixOS Config";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    draconis.url = "github:marsupialgutz/draconis";
    flake-firefox-nightly.url = "github:colemickens/flake-firefox-nightly";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixvim.url = "github:pta2002/nixvim";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nur.url = "github:nix-community/NUR";
    replugged-overlay.url = "github:marsupialgutz/replugged-nix-flake-fixed";
    helix.url = "github:marsupialgutz/helix-insert";
    vscodeInsiders.url = "github:cideM/visual-studio-code-insiders-nix";
    polymc.url = "github:PolyMC/PolyMC";

    better-codeblocks = {
      url = "github:replugged-org/better-codeblocks";
      flake = false;
    };

    catppuccin = {
      url = "github:catppuccin/discord";
      flake = false;
    };

    chat-components = {
      url = "github:12944qwerty/chat-components";
      flake = false;
    };

    context-icons = {
      url = "github:CreArts-Community/Context-Icons";
      flake = false;
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fluent-icons = {
      url = "github:stickfab/pc-fluenticons";
      flake = false;
    };

    hastebin = {
      url = "github:replugged-org/hastebin";
      flake = false;
    };

    holy-notes = {
      url = "github:SammCheese/holy-notes";
      flake = false;
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

    lavender = {
      url = "github:Lavender-Discord/Lavender";
      flake = false;
    };

    pronoundb = {
      url = "github:katlyn/pronoundb-powercord";
      flake = false;
    };

    simple-discord-crypt = {
      url = "github:SammCheese/SimpleDiscordCryptLoader";
      flake = false;
    };

    spotify-modal = {
      url = "github:replugged-org/spotify-modal";
      flake = false;
    };

    theme-toggler = {
      url = "github:redstonekasi/theme-toggler";
      flake = false;
    };

    tiktok-tts = {
      url = "github:oatmealine/powercord-tiktok-tts";
      flake = false;
    };

    vpc-spotimbed = {
      url = "github:Vap0r1ze/vpc-spotimbed";
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
    agenix,
    fenix,
    helix,
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
    defaultPackage.x86_64-linux = fenix.packages.x86_64-linux.minimal.toolchain;
    homeConfigurations.marshall = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {inherit inputs;};
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
          allowBroken = true;
        };
        overlays = [(import ./pkgs inputs)];
      };
      modules = [
        ./home
        {
          home.stateVersion = "22.05";
          home.username = "marshall";
          # NOTE: change me if you change the dir in nixos config
          home.homeDirectory = "/home/marshall";
        }
      ];
    };

    nixosConfigurations = {
      nix = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};

        modules = [
          ./sys/nix/configuration.nix
          agenix.nixosModule
          hyprland.nixosModules.default
        ];
      };

      wsl = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};

        modules = [
          ./sys/wsl.nix
          agenix.nixosModule
          nixos-wsl.nixosModules.wsl
        ];
      };
    };

    apps.x86_64-linux.update-home = {
      type = "app";
      program =
        (inputs.nixpkgs.legacyPackages.x86_64-linux.writeScript "update-home" ''
          set -euo pipefail
          old_profile=$(nix profile list | grep home-manager-path | head -n1 | awk '{print $4}')
          echo $old_profile
          nix profile remove $old_profile
          ${self.homeConfigurations.marshall.activationPackage}/activate || (echo "restoring old profile"; ${self.legacyPackages.x86_64-linux.nix}/bin/nix profile install $old_profile)
        '')
        .outPath;
    };

    devShells = forSystems (
      system: let
        pkgs = nixpkgs.legacyPackages."${system}";
      in {
        default = pkgs.mkShellNoCC {
          packages = with pkgs; [nvfetcher agenix.defaultPackage.${system}];
        };
      }
    );
  };
}
