inputs: final: prev: let
  sources = prev.callPackage ./_sources/generated.nix {};
in {
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

  web-greeter = final.callPackage ./web-greeter.nix {
    web-greeter-src = inputs.web-greeter;
  };

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
  mySddmTheme = prev.plasma5Packages.callPackage ./aerial-sddm-theme {inherit sources;};
}
