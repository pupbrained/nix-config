{ mkYarnPackage, callPackage }:

let sources = callPackage ./_sources/generated.nix { };

in
mkYarnPackage {
  inherit (sources.nody-greeter) src pname version;
}
