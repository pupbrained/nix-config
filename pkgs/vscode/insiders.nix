{
  stdenv,
  lib,
  path,
  callPackage,
  fetchurl,
  commandLineArgs ? "",
}: let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  plat =
    {
      x86_64-linux = "linux-x64";
      x86_64-darwin = "darwin";
      aarch64-linux = "linux-arm64";
      aarch64-darwin = "darwin-arm64";
      armv7l-linux = "linux-armhf";
    }
    .${system}
    or throwSystem;

  archive_fmt =
    if stdenv.isDarwin
    then "zip"
    else "tar.gz";

  sha256 =
    {
      x86_64-linux = "144rpi8jwavdip6xlnjdbp7d6csplsg4plif94r0k2r89laic7la";
      x86_64-darwin = "1xm2qgz35zrz0wlif775sz1sk0wx5gmdn1g5g84xpw1h9yimb656";
      aarch64-linux = "1iwg997dih369qhq2cian7qc1dgpy8x2lj4qxc5mvj1xbq0a0i52";
      aarch64-darwin = "1nii1qsp6l5x24ndfi5d5s145873l5fqclpv4gcqfabw7p7vcqzj";
      armv7l-linux = "148s6g470r6vfphfqg33p20ck364rrn70w00badn6a4kzlgjmhyz";
    }
    .${system}
    or throwSystem;
in
  callPackage "${path}/pkgs/applications/editors/vscode/generic.nix" rec {
    version = "1.81.0-insider";
    pname = "vscode-insiders";
    updateScript = ./update-vscode-insiders.sh;

    executableName = "code-insiders";
    longName = "Visual Studio Code - Insiders";
    shortName = "Code - Insiders";
    inherit commandLineArgs;

    src = fetchurl {
      name = "VSCode_${version}_${plat}.${archive_fmt}";
      url = "https://update.code.visualstudio.com/${version}/${plat}/insider";
      inherit sha256;
    };
    sourceRoot = "";

    meta = with lib; {
      description = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS
      '';
      longDescription = ''
        Open source source code editor developed by Microsoft for Windows,
        Linux and macOS. It includes support for debugging, embedded Git
        control, syntax highlighting, intelligent code completion, snippets,
        and code refactoring. It is also customizable, so users can change the
        editor's theme, keyboard shortcuts, and preferences
      '';
      homepage = "https://code.visualstudio.com/";
      downloadPage = "https://code.visualstudio.com/Updates";
      license = licenses.unfree;
      mainProgram = "code-insiders";
      platforms = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
        "aarch64-linux"
        "armv7l-linux"
      ];
    };
  }
