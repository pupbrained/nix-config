inputs:
inputs.nixpkgs.lib.composeManyExtensions [
  (final: prev: let
    sources = prev.callPackage ./_sources/generated.nix {};
  in {
    inherit (inputs.vscodeInsiders.packages.${prev.system}) vscodeInsiders;
    inherit (inputs.flake-firefox-nightly.packages.${prev.system}) firefox-nightly-bin;

    draconis = inputs.draconis.defaultPackage.${prev.system};
    riff = inputs.riff.defaultPackage.${prev.system};
    inherit (inputs.nil.packages.${prev.system}) nil;
    tre = inputs.tre.defaultPackage.${prev.system};
    nix-snow = inputs.nix-snow.defaultPackage.${prev.system};
    fleet = prev.rustPlatform.buildRustPackage rec {
      inherit (sources.fleet) pname version src;
      cargoLock = sources.fleet.cargoLock."Cargo.lock";

      buildInputs = [prev.pkgs.openssl];
      nativeBuildInputs = [prev.pkgs.pkg-config];
    };

    openasar = prev.stdenv.mkDerivation rec {
      inherit (sources.openasar) pname version src;
    };

    discord-canary = prev.discord-canary.override {
      nss = final.nss_latest;
      openasar = prev.pkgs.callPackage ./openasar.nix {};
      withOpenASAR = true;
    };

    nvui = prev.pkgs.callPackage ./nvui.nix {};

    waybar = prev.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      patchPhase = ''
        substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle_);" "const std::string command = \"hyprctl dispatch workspace \" + name_; system(command.c_str());"
      '';
    });

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
  inputs.fenix.overlay
  inputs.polymc.overlay
]
