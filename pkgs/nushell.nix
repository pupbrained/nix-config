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

    extraEnv = ''
      let-env EMACS_PATH_COPILOT = "${pkgs.fetchFromGitHub {
        owner = "zerolfx";
        repo = "copilot.el";
        rev = "05ffaddc5025d0d4e2424213f4989fc1a636ee31";
        hash = "sha256-K51HH8/ZkXXzmxCFqxsWn+o2hR3IPejkfQv7vgWBArQ=";
      }}";
    '';
  };
}
