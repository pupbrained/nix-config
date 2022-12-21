inputs:
inputs.nixpkgs.lib.composeManyExtensions [
  (final: prev: let
    sources = prev.callPackage ./_sources/generated.nix {};

    catppuccin = "${prev.fetchFromGitHub {
      owner = "catppuccin";
      repo = "discord";
      rev = "d65e21cf2302355e1d8a50fe8f7714f6ebb1261d";
      sha256 = "sha256-EN4YKCzkYe9xOtv9tPLPVHXJOj1XODrnLy+SSZWObSY=";
    }}/themes/mocha.theme.css";

    hsl = "${prev.fetchFromGitHub {
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
    sf-mono-liga-src = inputs.sf-mono-liga;

    discord-patched = inputs.vencord.packages.${prev.system}.discord-patched.override {
      inherit (final) discord-canary;
    };

    draconis = inputs.draconis.defaultPackage.${prev.system};
    riff = inputs.riff.defaultPackage.${prev.system};
    glrnvim = inputs.glrnvim.defaultPackage.${prev.system};
    tre = inputs.tre.defaultPackage.${prev.system};
    nix-snow = inputs.nix-snow.defaultPackage.${prev.system};

    adi1090x-plymouth = final.callPackage ./adi1090x-plymouth.nix {};
    catppuccin-cursors = final.callPackage ./catppuccin-cursors.nix {};
    catppuccin-folders = final.callPackage ./catppuccin-folders.nix {};
    gradience = final.callPackage ./gradience.nix {};
    httpie-desktop = final.callPackage ./httpie-desktop.nix {};
    jetbrains-fleet = final.callPackage ./fleet.nix {};
    nvui = final.libsForQt5.callPackage ./nvui.nix {};
    python-material-color-utilities = final.callPackage ./material-color-utilities.nix {};
    revolt = final.callPackage ./revolt.nix {};
    sf-mono-liga = final.callPackage ./sf-mono-liga.nix {
      src = final.sf-mono-liga-src;
      version = "999-master";
    };
    nushell-pkg = final.callPackage ./nushell-pkg.nix {};

    kitty = prev.python3Packages.buildPythonApplication rec {
      inherit (prev.kitty) pname buildInputs outputs patches preCheck buildPhase nativeBuildInputs dontConfigure hardeningDisable installPhase preFixup passthru meta;
      version = "0.26.5";
      format = "other";
      src = prev.fetchFromGitHub {
        owner = "kovidgoyal";
        repo = "kitty";
        rev = "v${version}";
        sha256 = "sha256-UloBlV26HnkvbzP/NynlPI77z09MBEVgtrg5SeTmwB4=";
      };
    };

    waybar = prev.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      patchPhase = ''
        substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle_);" "const std::string command = \"hyprctl dispatch workspace \" + name_; system(command.c_str());"
      '';
    });

    bluez = prev.bluez.overrideAttrs (oldAttrs: {
      doCheck = false;
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

    nvim-nu = prev.vimUtils.buildVimPlugin {
      inherit (sources.nvim-nu) src pname version;
    };

    move-nvim = prev.vimUtils.buildVimPlugin {
      inherit (sources.move-nvim) src pname version;
    };

    libsForQt5 =
      prev.libsForQt5
      // {
        sddm = prev.libsForQt5.sddm.overrideAttrs (o: {
          inherit (sources.sddm) src pname version;
          patches = [
            ./sddm-ignore-config-mtime.patch
            ./sddm-default-session.patch
          ];
        });
      };

    spotifywm-fixed = prev.spotifywm.overrideAttrs (o: {
      src = prev.fetchFromGitHub {
        owner = "amurzeau";
        repo = "spotifywm";
        rev = "a2b5efd5439b0404f1836cc9a681417627531a00";
        sha256 = "03bvm6nb9524km28h6mazs6613lvcmyzp1kg9iql2pcli9rfmi82";
      };
    });

    starfetch = prev.starfetch.overrideAttrs (o: {
      version = "0.0.4";

      src = prev.fetchFromGitHub {
        owner = "Haruno19";
        repo = "starfetch";
        rev = "0.0.4";
        sha256 = "sha256-I2M/FlLRkGtD2+GcK1l5+vFsb5tCb4T3UJTPxRx68Ww=";
      };
    });

    mpv-unwrapped = prev.mpv-unwrapped.overrideAttrs (o: {
      src = prev.fetchFromGitHub {
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

    discord-plugged = inputs.replugged.packages.${prev.system}.discord-plugged.override {
      inherit (final) discord-canary;
    };

    firefox-addons = prev.callPackages ./firefox-addons {};

    sddm-dexy-theme = inputs.nixpkgs-old.legacyPackages.${prev.system}.plasma5Packages.callPackage ./sddm-theme.nix {inherit sources;};

    inherit (inputs.nixpkgs-old.legacyPackages.${prev.system}.qt5) qtwebengine;
  })

  inputs.fenix.overlays.default
]
