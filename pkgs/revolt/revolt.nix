{
  lib,
  newScope,
  stdenv,
  pkgs,
  callPackage,
}:
lib.makeScope newScope (self: {
  revolt = callPackage ({
    pkgs,
    stdenv,
    electron,
    mkYarnPackage,
  }: let
    rev = "19df085e793643b44b55bee76cdd8f00b891a106";
    sha256 = "07g3cmb1dn6gvnc5w6shc81bdalsh74jr8rr15w67qk4w593lf5y";
    src = pkgs.fetchFromGitHub {
      owner = "revoltchat";
      repo = "Desktop";
      inherit rev sha256;
    };
  in
    mkYarnPackage rec {
      name = "revolt-${rev}";
      inherit src;
      packageJSON = ./package.json;
      yarnLock = ./yarn.lock;

      buildInputs = [electron];

      pname = "Revolt";
      installPhase = ''
        ls -al
        runHook preInstall
        mkdir -p $out/{bin,libexec/${pname}}
        mv node_modules $out/libexec/${pname}/node_modules
        mv deps $out/libexec/${pname}/deps
        runHook postInstall
      '';

      distPhase = ''
        cd $out
        unlink "$out/libexec/${pname}/deps/${pname}/node_modules"
        ln -s "$out/libexec/${pname}/node_modules" "$out/libexec/${pname}/deps/${pname}/desktop/node_modules"
        ls -al
        ls -al libexec
        mkdir -p bin
        cd bin
        echo '#!/bin/sh' > revolt
        echo "cd $out/libexec/${pname}/deps/${pname}" >> revolt
        echo "${electron}/bin/electron $out/libexec/${pname}/deps/${pname}/desktop" >> revolt
        chmod 0755 $out/bin/revolt
        true
      '';
    }) {};
})
