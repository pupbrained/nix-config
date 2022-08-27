{
  description = "Marshall's NixOS Config";

  inputs = {
    draconis.url = "github:marsupialgutz/draconis";
    flake-firefox-nightly.url = "github:colemickens/flake-firefox-nightly";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs.url = "github:nixos/nixpkgs";
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

    nixosConfigurations = {
      nix = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};

        modules = [
          ./sys/nix/configuration.nix
          home-manager.nixosModule
          hyprland.nixosModules.default
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
