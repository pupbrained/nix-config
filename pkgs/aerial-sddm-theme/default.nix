{ sources, qtgraphicaleffects, qtmultimedia, qtquickcontrols, mkDerivation }:

mkDerivation {
  inherit (sources.aerial-sddm-theme) src pname version;
  propagatedUserEnvPkgs = [qtgraphicaleffects qtmultimedia qtquickcontrols];
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -r ./. $out/share/sddm/themes/aerial-sddm-theme
  '';
}
