{
  description = "Marshall's NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    nur.url = "github:nix-community/NUR";

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
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nur
    , powercord-overlay
    , neovim-nightly-overlay
    , vscodeInsiders
    , theme-toggler
    , powercord-tiktok-tts
    , lavender-discord
    , catppuccin
    , flake-firefox-nightly
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        nix = lib.nixosSystem {
          inherit system;
          modules = [ ./sys/configuration.nix ];
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
              {
                nixpkgs.overlays = [
                  (self: super: {
                    vscodeInsiders =
                      vscodeInsiders.packages.${super.system}.vscodeInsiders;
                  })
                  powercord-overlay.overlay
                  nur.overlay
                  neovim-nightly-overlay.overlay
                ];
                nixpkgs.config.allowUnfree = true;
              }

              ({ pkgs, config, ... }: {
                home.packages = with pkgs; [
                  pkgs.nur.repos.marsupialgutz.draconis
                  flake-firefox-nightly.packages.x86_64-linux.firefox-nightly-bin
                  zsh
                  kitty
                  neovim-nightly
                  (pkgs.discord-plugged.override {
                    plugins = [ theme-toggler powercord-tiktok-tts ];
                    themes = [ lavender-discord catppuccin ];
                  })
                  acpi
                  acpid
                  audacity
                  binutils
                  brightnessctl
                  cargo-binutils
                  chrome-gnome-shell
                  cinnamon.nemo
                  cmake
                  dbus
                  dbus.dev
                  exa
                  feh
                  ffmpeg
                  file
                  gcc
                  gh
                  gnomeExtensions.appindicator
                  gnomeExtensions.pop-shell
                  gnome.gnome-tweaks
                  gnome.seahorse
                  gnumake
                  gnupg
                  gpick
                  headsetcontrol
                  jamesdsp
                  jq
                  keychain
                  killall
                  kotatogram-desktop
                  libnotify
                  lua52Packages.lgi
                  lxappearance
                  mate.engrampa
                  micro
                  minecraft
                  mpd
                  mpv
                  ncmpcpp
                  neovide
                  nerdfonts
                  nixfmt
                  nix-prefetch-scripts
                  nodejs
                  noto-fonts-cjk-sans
                  pamixer
                  papirus-icon-theme
                  pavucontrol
                  playerctl
                  polymc
                  python
                  python310
                  redshift
                  rofi
                  rustup
                  rust-analyzer
                  scrot
                  spicetify-cli
                  spot
                  sumneko-lua-language-server
                  unrar
                  unzip
                  upower
                  uutils-coreutils
                  wineWowPackages.full
                  xclip
                  xdotool
                  yarn
                  zoxide
                ];
                programs.vscode = with pkgs; {
                  enable = true;
                  package = vscodeInsiders;
                };

                programs.git = {
                  enable = true;
                  userName = "marsupialgutz";
                  userEmail = "mars@possums.xyz";
                };

                services.picom = {
                  enable = true;
                  blur = true;
                  extraOptions = ''
                    blur-method = "dual_kawase";
                    strength = 15;
                  '';
                  experimentalBackends = true;

                  shadowExclude = [ "bounding_shaped && !rounded_corners" ];

                  fade = true;
                  fadeDelta = 7;
                  vSync = true;
                  opacityRule = [
                    "100:class_g   *?= 'Chromium-browser'"
                    "100:class_g   *?= 'Firefox'"
                    "100:class_g   *?= 'gitkraken'"
                    "100:class_g   *?= 'emacs'"
                    "100:class_g   ~=  'jetbrains'"
                    "100:class_g   *?= 'slack'"
                  ];
                  package = pkgs.picom.overrideAttrs (o: {
                    src = pkgs.fetchFromGitHub {
                      repo = "picom";
                      owner = "ibhagwan";
                      rev = "44b4970f70d6b23759a61a2b94d9bfb4351b41b1";
                      sha256 = "0iff4bwpc00xbjad0m000midslgx12aihs33mdvfckr75r114ylh";
                    };
                  });
                };
              })
            ];
          };
        };
      };
    };
}
