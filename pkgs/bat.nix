{
  config,
  pkgs,
  inputs,
  self,
  lib,
  ...
}: {
  programs.bat = with pkgs; {
    enable = true;
    config.theme = "catppuccin";

    themes = {
      catppuccin = builtins.readFile (fetchFromGitHub
        {
          owner = "catppuccin";
          repo = "sublime-text";
          rev = "0b7ac201ce4ec7bac5e0063b9a7483ca99907bbf";
          sha256 = "1kn5v8g87r6pjzzij9p8j7z9afc6fj0n8drd24qyin8p1nrlifi1";
        }
        + "/Catppuccin.tmTheme");
    };
  };
}
