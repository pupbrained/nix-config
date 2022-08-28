inputs:
inputs.nixpkgs.lib.composeManyExtensions [
  (final: prev: let
    sources = prev.callPackage ./_sources/generated.nix {};
  in {
    inherit (inputs.vscodeInsiders.packages.${prev.system}) vscodeInsiders;
    inherit (inputs.flake-firefox-nightly.packages.${prev.system}) firefox-nightly-bin;

    draconis = inputs.draconis.defaultPackage.${prev.system};

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

    picom = prev.picom.overrideAttrs (o: {
      inherit (sources.picom) src pname version;
    });

    lapce = prev.lapce.overrideAttrs (o: {
      inherit (sources.lapce) src pname version;
      cargoSha256 = "0000000000000000000000000000000000000000000000000000";
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

    wlroots = prev.wlroots.overrideAttrs (oldAttrs: {
      patchPhase = ''
        substituteInPlace render/gles2/renderer.c --replace "glFlush();" "glFinish();"
      '';
    });

    hyprland-nvidia = inputs.hyprland.packages.${prev.system}.default.override {inherit (final) wlroots;};

    awesome =
      (prev.awesome.overrideAttrs (old: {
        inherit (sources.awesome) src pname version;
        patches = [];
        GI_TYPELIB_PATH =
          "${prev.playerctl}/lib/girepository-1.0:"
          + "${prev.upower}/lib/girepository-1.0:"
          + old.GI_TYPELIB_PATH;
      }))
      .override {
        stdenv = prev.clangStdenv;
        gtk3Support = true;
      };

    mySddmTheme = prev.plasma5Packages.callPackage ./astronaut-sddm-theme {inherit sources;};
  })
  inputs.replugged-overlay.overlay
  inputs.nur.overlay
  inputs.neovim-nightly-overlay.overlay
  inputs.fenix.overlay
  inputs.nixpkgs-wayland.overlay
  inputs.polymc.overlay
]
