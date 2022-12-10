{
  config,
  pkgs,
  inputs,
  self,
  ...
}: {
  programs.nushell = {
    enable = true;

    configFile.source = "${self}/dotfiles/nushell/config.nu";
    envFile.source = "${self}/dotfiles/nushell/env.nu";
  };
}
