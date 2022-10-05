{
  description = "Marshall's NixOS Config";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    draconis.url = "github:pupbrained/draconis";
    flake-firefox-nightly.url = "github:colemickens/flake-firefox-nightly";
    glrnvim.url = "github:pupbrained/glrnvim-nix";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    nil.url = "github:oxalica/nil";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-snow.url = "github:pupbrained/nix-snow";
    replugged-overlay.url = "github:LunNova/replugged-nix-flake";
    riff.url = "github:DeterminateSystems/riff";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    tre.url = "github:dduan/tre";
    vscodeInsiders.url = "github:cideM/visual-studio-code-insiders-nix";
    polymc.url = "github:PolyMC/PolyMC";

    better-codeblocks = {
      url = "github:replugged-org/better-codeblocks";
      flake = false;
    };

    canary-links = {
      url = "github:asportnoy/canary-links";
      flake = false;
    };

    cc-plugins = {
      url = "github:CumcordLoaders/Powercord";
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

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
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

    termful = {
      url = "github:FromSyntax/termful";
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
    nixpkgs,
    home-manager,
    nixos-wsl,
    nix-ld,
    nix-doom-emacs,
    hyprland,
    spicetify-nix,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    forSystems = lib.genAttrs lib.systems.flakeExposed;
  in {
    defaultPackage.x86_64-linux = fenix.packages.x86_64-linux.latest.toolchain;
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
          nix-ld.nixosModules.nix-ld
        ];
      };

      wsl = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};

        modules = [
          ./sys/wsl.nix
          agenix.nixosModule
          nixos-wsl.nixosModules.wsl
          nix-ld.nixosModules.nix-ld
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
          ${self.homeConfigurations.marshall.activationPackage}/activate || (echo "restoring old profile"; ${inputs.nixpkgs.legacyPackages.x86_64-linux.nix}/bin/nix profile install $old_profile)
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
