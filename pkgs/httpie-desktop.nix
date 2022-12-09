{
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 {
  name = "httpie";
  src = fetchurl {
    url = "https://github.com/httpie/desktop/releases/download/v2022.16.0/HTTPie-2022.16.0.AppImage";
    sha256 = "sha256-zWXIidAVQGNGgA0W3d1XOzr/vDq/QX06gEpUT4O6Awk=";
  };
}
