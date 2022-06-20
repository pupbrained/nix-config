{
  sources,
  qtgraphicaleffects,
  qtmultimedia,
  qtquickcontrols,
  gstreamer,
  phonon,
  phonon-backend-gstreamer,
  gst_all_1,
  mkDerivation,
}:
mkDerivation {
  inherit (sources.aerial-sddm-theme) src pname version;
  propagatedUserEnvPkgs = [gst_all_1.gst-plugins-good phonon phonon-backend-gstreamer qtgraphicaleffects qtmultimedia qtquickcontrols];
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -r ./. $out/share/sddm/themes/aerial-sddm-theme
    cp ${./theme.conf} $out/share/sddm/themes/aerial-sddm-theme/theme.conf.user
  '';
}
