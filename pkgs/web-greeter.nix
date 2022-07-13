{ nodejs, rsync, pkg-config, python3Packages, callPackage }:

let sources = callPackage ./_sources/generated.nix { };
in
python3Packages.buildPythonApplication {
  inherit (sources.web-greeter) src pname version;
  nativeBuildInputs = [ nodejs rsync pkg-config ];
  __noChroot = true;
  buildPhase = ''
    HOME=$(mktemp -d)
    # fuck it
    npm exec --package=typescript -- make
  '';
  installPhase = ''
    make install
  '';
}
