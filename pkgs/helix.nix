{
  pkgs,
  lib,
  ...
}: let
  sources = pkgs.callPackage ./_sources/generated.nix {};
in {
  programs.helix = {
    enable = false;

    package = pkgs.rustPlatform.buildRustPackage {
      inherit (sources.helix) src pname version;
      cargoLock = sources.helix.cargoLock."Cargo.lock";

      nativeBuildInputs = with pkgs; [installShellFiles makeWrapper];

      postInstall = ''
        rm -r runtime/grammars/sources
        mkdir -p $out/lib
        cp -r runtime $out/lib
        installShellCompletion contrib/completion/hx.{bash,fish,zsh}
        mkdir -p $out/share/{applications,icons/hicolor/256x256/apps}
        cp contrib/Helix.desktop $out/share/applications
        cp contrib/helix.png $out/share/icons/hicolor/256x256/apps
      '';

      postFixup = ''
        wrapProgram $out/bin/hx --set HELIX_RUNTIME $out/lib/runtime
      '';

      meta = with lib; {
        description = "A post-modern modal text editor";
        homepage = "https://helix-editor.com";
        license = licenses.mpl20;
        mainProgram = "hx";
      };
    };
  };
}
