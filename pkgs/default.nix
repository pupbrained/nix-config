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
    inherit (inputs.vencord.packages.${prev.system}) vencord;

    draconis = inputs.draconis.defaultPackage.${prev.system};
    riff = inputs.riff.defaultPackage.${prev.system};
    glrnvim = inputs.glrnvim.defaultPackage.${prev.system};
    tre = inputs.tre.defaultPackage.${prev.system};
    nix-snow = inputs.nix-snow.defaultPackage.${prev.system};

    revolt = final.callPackage ./revolt.nix {};
    nvui = prev.libsForQt5.callPackage ./nvui.nix {};

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

    hyprland-nvidia = inputs.hyprland.packages.${prev.system}.default.override {
      nvidiaPatches = true;
    };
  })

  inputs.fenix.overlay
  inputs.polymc.overlay
]
