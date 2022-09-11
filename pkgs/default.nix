inputs:
inputs.nixpkgs.lib.composeManyExtensions [
  (final: prev: let
    sources = prev.callPackage ./_sources/generated.nix {};
  in {
    inherit (inputs.vscodeInsiders.packages.${prev.system}) vscodeInsiders;
    inherit (inputs.flake-firefox-nightly.packages.${prev.system}) firefox-nightly-bin;

    draconis = inputs.draconis.defaultPackage.${prev.system};
    nix-snow = inputs.nix-snow.packages.${prev.system}.default;
    nix-software-center = inputs.nix-software-center.defaultPackage.${prev.system};
    nixos-conf-editor = inputs.nixos-conf-editor.defaultPackage.${prev.system};
    fleet = prev.rustPlatform.buildRustPackage rec {
      inherit (sources.fleet) pname version src;
      cargoLock = sources.fleet.cargoLock."Cargo.lock";

      buildInputs = [prev.pkgs.openssl];
      nativeBuildInputs = [prev.pkgs.pkg-config];
    };

    discord = prev.discord.override {
      withOpenASAR = true;
    };

    discord-canary = prev.discord-canary.override {
      nss = final.nss_latest;
    };

    waybar = prev.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      patchPhase = ''
        substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle_);" "const std::string command = \"hyprctl dispatch workspace \" + name_; system(command.c_str());"
      '';
    });

    spicetify-cli = with prev;
      spicetify-cli.overrideAttrs (_: {
        inherit (sources.spicetify-cli) pname version src;
        postInstall = ''
          cp -r ./jsHelper ./Themes ./Extensions ./CustomApps ./globals.d.ts ./css-map.json $out/bin
        '';
      });

    spicetify-themes = sources.spicetify-themes.src;
    catppuccin-spicetify = sources.catppuccin-spicetify.src;
    spotify-spicetified = final.callPackage ./spotify-spicetified {};

    zscroll = prev.zscroll.overrideAttrs (o: {
      inherit (sources.zscroll) src pname version;
    });

    myCopilotVim = prev.vimPlugins.copilot-vim.overrideAttrs (o: {
      inherit (sources.copilot-vim) src pname version;
    });

    myCokelinePlugin = prev.vimUtils.buildVimPlugin {
      inherit (sources.nvim-cokeline) src pname version;
    };

    myTailwindPlugin = prev.vimUtils.buildVimPlugin {
      inherit (sources.coc-tailwindcss3) src pname version;
    };

    myAstroPlugin = prev.vimUtils.buildVimPlugin {
      inherit (sources.vim-astro) src pname version;
    };

    web-greeter = final.callPackage ./web-greeter.nix {
      web-greeter-src = inputs.web-greeter;
    };

    revolt = final.callPackage ./revolt.nix {};

    hyprland-nvidia = inputs.hyprland.packages.${prev.system}.default.override {
      nvidiaPatches = true;
    };

    mySddmTheme = prev.plasma5Packages.callPackage ./astronaut-sddm-theme {inherit sources;};
  })
  inputs.replugged-overlay.overlay
  inputs.nur.overlay
  inputs.fenix.overlay
  inputs.polymc.overlay
]
