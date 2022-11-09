{
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 {
  name = "httpie";
  src = fetchurl {
    url = "https://github.com/httpie/desktop/releases/download/v2022.15.1/HTTPie-2022.15.1.AppImage";
    sha256 = "sha256-/KBVowXZClvQ+ya8wOw6HFCQhcQ9Mwtjg3H0ZOd/qGY=";
  };
}
