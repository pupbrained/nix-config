{
  sources,
  qtgraphicaleffects,
  qtquickcontrols2,
  qtsvg,
  sddm,
  plasma-framework,
  plasma-workspace,
  mkDerivation,
}:
mkDerivation {
  inherit (sources.sddm-theme) src pname version;
  propagatedUserEnvPkgs = [qtgraphicaleffects qtquickcontrols2 qtsvg sddm plasma-framework plasma-workspace];
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -r ./Dexy-SDDM $out/share/sddm/themes/dexy-theme
  '';
}
