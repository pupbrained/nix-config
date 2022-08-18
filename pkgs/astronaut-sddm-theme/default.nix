{
  sources,
  qtgraphicaleffects,
  qtmultimedia,
  qtquickcontrols,
  phonon,
  phonon-backend-gstreamer,
  gst_all_1,
  mkDerivation,
}:
mkDerivation {
  inherit (sources.astronaut-sddm-theme) src pname version;
  propagatedUserEnvPkgs = [qtgraphicaleffects qtquickcontrols2 qtsvg sddm];
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -r ./. $out/share/sddm/themes/astronaut-sddm-theme
    #cp ${./theme.conf} $out/share/sddm/themes/astronaut-sddm-theme/theme.conf
  '';
}
