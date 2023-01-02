{
  description = "Marshall's NixOS Config";

  inputs = {
    agenix.url = "github:yaxitech/ragenix";
    draconis.url = "github:pupbrained/draconis";
    flake-firefox-nightly.url = "github:colemickens/flake-firefox-nightly";
    glrnvim.url = "github:pupbrained/glrnvim-nix";
    home-manager.url = "github:nix-community/home-manager";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib.url = "github:hyprwm/contrib";
    neovim.url = "github:neovim/neovim?dir=contrib";
    nil.url = "github:oxalica/nil";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-catppuccin.url = "github:fufexan/nixpkgs/catppuccin";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixvim.url = "github:pta2002/nixvim";
    nix-snow.url = "github:pupbrained/nix-snow";
    nur.url = "github:nix-community/NUR";
    nurl.url = "github:nix-community/nurl";
    prism-launcher.url = "github:PrismLauncher/PrismLauncher";
    replugged.url = "github:pupbrained/replugged";
    riff.url = "github:DeterminateSystems/riff";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    tre.url = "github:dduan/tre";
    xdg-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
  };

  outputs = {
    agenix,
    fenix,
    home-manager,
    hyprland,
    hyprland-contrib,
    neovim,
    nixos-wsl,
    nixpkgs,
    nixpkgs-old,
    nur,
    nurl,
    replugged,
    spicetify-nix,
    xdg-hyprland,
    self,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;
    forSystems = lib.genAttrs lib.systems.flakeExposed;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [(import ./pkgs inputs)];
    };
  in {
    homeConfigurations = {
      marshall = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs self spicetify-nix hyprland-contrib xdg-hyprland;};
        modules = [
          ./home
          {
            home.stateVersion = "22.05";
            home.username = "marshall";
            home.homeDirectory = "/home/marshall";
          }
        ];
      };

      server = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs;};

        modules = [
          ./home/server.nix
          {
            home.stateVersion = "23.05";
            home.username = "marshall";
            home.homeDirectory = "/home/marshall";
          }
        ];
      };
    };

    nixosConfigurations = {
      nix = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs self xdg-hyprland;};

        modules = [
          ./sys/nix/configuration.nix
          agenix.nixosModules.age
          hyprland.nixosModules.default
          nur.nixosModules.nur
        ];
      };

      wsl = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};

        modules = [
          ./sys/wsl.nix
          agenix.nixosModules.age
          nixos-wsl.nixosModules.wsl
          nur.nixosModules.nur
        ];
      };

      server = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};

        modules = [
          ./sys/server/configuration.nix
          agenix.nixosModules.age
          nur.nixosModules.nur
        ];
      };
    };

    apps.x86_64-linux = {
      update-home = {
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

      update-server-home = {
        type = "app";
        program =
          (inputs.nixpkgs.legacyPackages.x86_64-linux.writeScript "update-server-home" ''
            set -euo pipefail
            old_profile=$(nix profile list | grep home-manager-path | head -n1 | awk '{print $4}')
            echo $old_profile
            nix profile remove $old_profile
            ${self.homeConfigurations.server.activationPackage}/activate || (echo "restoring old profile"; ${inputs.nixpkgs.legacyPackages.x86_64-linux.nix}/bin/nix profile install $old_profile)
          '')
          .outPath;
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
