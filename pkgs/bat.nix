{
  config,
  pkgs,
  ...
}: {
  programs.bat = with pkgs; {
    enable = true;
    config.theme = "catppuccin";

    themes = {
      catppuccin = builtins.readFile (fetchFromGitHub
        {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          hash = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        }
        + "/Catppuccin-mocha.tmTheme");
    };
  };
}
