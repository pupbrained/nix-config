inputs:
inputs.nixpkgs.lib.composeManyExtensions [
  (final: prev: let
    sources = prev.callPackage ./_sources/generated.nix {};

    catppuccin = "${prev.pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "discord";
      rev = "d65e21cf2302355e1d8a50fe8f7714f6ebb1261d";
      sha256 = "sha256-EN4YKCzkYe9xOtv9tPLPVHXJOj1XODrnLy+SSZWObSY=";
    }}/themes/mocha.theme.css";

    hsl = "${prev.pkgs.fetchFromGitHub {
      owner = "DiscordStyles";
      repo = "HorizontalServerList";
      rev = "b9fc8862f4bd1f24e575a687dbcf096ab338fe7f";
      sha256 = "sha256-OIs3aI30cNyUYqSogGzzE4qsbIvtciON5aI+huag4Pg=";
    }}/src/dist.css";
  in {
    inherit (inputs.vscodeInsiders.packages.${prev.system}) vscodeInsiders;
    inherit (inputs.flake-firefox-nightly.packages.${prev.system}) firefox-nightly-bin;
    inherit (inputs.nil.packages.${prev.system}) nil;
    inherit (inputs.prism-launcher.packages.${prev.system}) prismlauncher;

    discord-patched = inputs.vencord.packages.${prev.system}.discord-patched.override {
      inherit (final) discord-canary;
    };

    draconis = inputs.draconis.defaultPackage.${prev.system};
    riff = inputs.riff.defaultPackage.${prev.system};
    glrnvim = inputs.glrnvim.defaultPackage.${prev.system};
    tre = inputs.tre.defaultPackage.${prev.system};
    nix-snow = inputs.nix-snow.defaultPackage.${prev.system};

    catppuccin-cursors = final.callPackage ./catppuccin-cursors.nix {};
    gradience = final.callPackage ./gradience.nix {};
    jetbrains-fleet = final.callPackage ./fleet.nix {};
    nvui = final.libsForQt5.callPackage ./nvui.nix {};
    python-material-color-utilities = final.callPackage ./material-color-utilities.nix {};
    revolt = final.callPackage ./revolt.nix {};

    kitty = prev.pkgs.python3Packages.buildPythonApplication rec {
      inherit (prev.kitty) pname buildInputs outputs patches preCheck buildPhase nativeBuildInputs dontConfigure hardeningDisable installPhase preFixup passthru meta;
      version = "0.26.3";
      format = "other";
      src = prev.pkgs.fetchFromGitHub {
        owner = "kovidgoyal";
        repo = "kitty";
        rev = "v${version}";
        sha256 = "sha256-pFucI80sz8AOfA/zDlGy/HLvj5Z4z8t10nunkKhwOWw=";
      };
    };

    waybar = prev.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      patchPhase = ''
        substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle_);" "const std::string command = \"hyprctl dispatch workspace \" + name_; system(command.c_str());"
      '';
    });

    zscroll = prev.zscroll.overrideAttrs (o: {
      inherit (sources.zscroll) src pname version;
    });

    copilot-vim = prev.vimPlugins.copilot-vim.overrideAttrs (o: {
      inherit (sources.copilot-vim) src pname version;
    });

    nvim-cokeline = prev.vimUtils.buildVimPlugin {
      inherit (sources.nvim-cokeline) src pname version;
    };

    spotifywm-fixed = prev.spotifywm.overrideAttrs (o: {
      src = prev.pkgs.fetchFromGitHub {
        owner = "amurzeau";
        repo = "spotifywm";
        rev = "a2b5efd5439b0404f1836cc9a681417627531a00";
        sha256 = "03bvm6nb9524km28h6mazs6613lvcmyzp1kg9iql2pcli9rfmi82";
      };
    });

    mpv-unwrapped = prev.mpv-unwrapped.overrideAttrs (o: {
      src = prev.pkgs.fetchFromGitHub {
        owner = "mpv-player";
        repo = "mpv";
        rev = "48ad2278c7a1fc2a9f5520371188911ef044b32c";
        sha256 = "sha256-6qbv34ysNQbI/zff6rAnVW4z6yfm2t/XL/PF7D/tjv4=";
      };
    });

    hyprland-nvidia = inputs.hyprland.packages.${prev.system}.default.override {
      nvidiaPatches = true;
    };

    discord-canary = prev.discord-canary.override {
      nss = final.nss_latest;
      openasar = final.callPackage ./openasar.nix {inherit (sources.openasar) src pname version;};
      withOpenASAR = true;
    };

    firefox-addons =
      prev.callPackages
      ./firefox-addons
      {};
  })

  inputs.fenix.overlay
]
