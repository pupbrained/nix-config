final: prev:

let
  sources = prev.callPackage ./_sources/generated.nix {};
in
{
  spicetify-cli = with prev; spicetify-cli.overrideAttrs (_: {
    inherit (sources.spicetify-cli) pname version src;
    postInstall = ''
      cp -r ./jsHelper ./Themes ./Extensions ./CustomApps ./globals.d.ts ./css-map.json $out/bin
    '';
  });
  picom = prev.picom.overrideAttrs (o: {
    inherit (sources.picom) src pname version;
  });
  awesome = (prev.awesome.overrideAttrs (old: {
    inherit (sources.awesome) src pname version;
    patches = [ ];
    GI_TYPELIB_PATH = "${prev.playerctl}/lib/girepository-1.0:"
      + "${prev.upower}/lib/girepository-1.0:"
      + old.GI_TYPELIB_PATH;
  })).override {
    stdenv = prev.clangStdenv;
    gtk3Support = true;
  };
}
