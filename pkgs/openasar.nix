{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  bash,
  nodePackages,
  unzip,
  src,
  pname,
  version,
}:
stdenv.mkDerivation rec {
  inherit pname version src;

  postPatch = ''
    # Hardcode unzip path
    substituteInPlace ./src/updater/moduleUpdater.js \
      --replace \'unzip\' \'${unzip}/bin/unzip\'
    # Remove auto-update feature
    echo "module.exports = async () => log('AsarUpdate', 'Removed');" > ./src/asarUpdate.js
  '';

  buildPhase = ''
    runHook preBuild
    substituteInPlace src/index.js --replace 'nightly' '${version}'
    ${nodejs}/bin/node scripts/strip.js
    ${nodePackages.asar}/bin/asar pack src app.asar
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install app.asar $out
    runHook postInstall
  '';

  doCheck = false;

  meta = with lib; {
    description = "Open-source alternative of Discord desktop's \"app.asar\".";
    homepage = "https://openasar.dev";
    license = licenses.mit;
    maintainers = with maintainers; [pedrohlc];
    inherit (nodejs.meta) platforms;
  };
}
