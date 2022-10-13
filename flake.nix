{
  description = "Marshall's NixOS Config";

  inputs = {
    agenix.url = "github:yaxitech/ragenix";
    draconis.url = "github:pupbrained/draconis";
    flake-firefox-nightly.url = "github:colemickens/flake-firefox-nightly";
    glrnvim.url = "github:pupbrained/glrnvim-nix";
    home-manager.url = "github:nix-community/home-manager";
    hyprland.url = "github:hyprwm/Hyprland";
    nil.url = "github:oxalica/nil";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-modded.url = "github:PedroHLC/nixpkgs/zen-kernels-6.0.1-zen1-5.19.15-lqx1";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-snow.url = "github:pupbrained/nix-snow";
    nur.url = "github:nix-community/NUR";
    polymc.url = "github:PolyMC/PolyMC";
    riff.url = "github:DeterminateSystems/riff";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    tre.url = "github:dduan/tre";
    vencord.url = "github:pupbrained/Vencord-nix";
    vscodeInsiders.url = "github:cideM/visual-studio-code-insiders-nix";
  };

  outputs = {
    self,
    agenix,
    fenix,
    nixpkgs,
    nixpkgs-modded,
    home-manager,
    nixos-wsl,
    nix-doom-emacs,
    nur,
    hyprland,
    spicetify-nix,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    lib-modded = nixpkgs-modded.lib;
    forSystems = lib.genAttrs lib.systems.flakeExposed;
  in {
    homeConfigurations.marshall = home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {inherit inputs;};
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        overlays = [(import ./pkgs inputs)];
      };
      modules = [
        ./home
        {
          home.stateVersion = "22.05";
          home.username = "marshall";
          home.homeDirectory = "/home/marshall";
        }
      ];
    };

    nixosConfigurations = {
      nix = lib-modded.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};

        modules = [
          ./sys/nix/configuration.nix
          agenix.nixosModules.age
          hyprland.nixosModules.default
          nur.nixosModules.nur
        ];
      };

      wsl = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};

        modules = [
          ./sys/wsl.nix
          agenix.nixosModule
          nixos-wsl.nixosModules.wsl
          nur.nixosModules.nur
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
          packages = with pkgs; [nvfetcher agenix.packages.${system}.default];
        };
      }
    );
  };
}
