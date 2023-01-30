{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  clang,
  libgit2,
  llvm,
  llvmPackages,
  openssl,
  sqlite,
  zlib,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "nushell";
  version = "unstable-2023-01-29";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    rev = "6ae497eedcbaa2667d36047939f2bb0989256b0c";
    hash = "sha256-VdEETDbWzJ4fHMONakNqSr08YJqrTioruIrjSrNk13Q=";
  };

  cargoHash = "sha256-RuP5XXQRIqXbQcMuEoK5hkAmLm2aL9MjJOrj1xz8/uE=";

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs =
    [
      clang
      libgit2
      llvm
      llvmPackages.libclang
      openssl
      sqlite
      zlib
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.DiskArbitration
      darwin.apple_sdk.frameworks.Foundation
      darwin.apple_sdk.frameworks.Security
    ];

  doCheck = false;

  meta = with lib; {
    description = "A new type of shell";
    homepage = "https://github.com/nushell/nushell";
    license = licenses.mit;
    maintainers = with maintainers; [];
  };
}
