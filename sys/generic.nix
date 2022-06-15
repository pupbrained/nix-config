{
  inputs,
  pkgs,
  ...
}: let
  sources = pkgs.callPackage ../_sources/generated.nix {};
in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      inherit (inputs.vscodeInsiders.packages.${super.system}) vscodeInsiders;
      inherit (inputs.flake-firefox-nightly.packages.${super.system}) firefox-nightly-bin;
      draconis =
        inputs.draconis.defaultPackage.${super.system};
    })
    inputs.powercord-overlay.overlay
    inputs.nur.overlay
    inputs.neovim-nightly-overlay.overlay
    inputs.fenix.overlay
    (import ../pkgs)
  ];

  nix = {
    package = pkgs.nixFlakes;
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
    binaryCaches = [
      "https://cache.nixos.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  home-manager = {
    # Pass inputs to all home-manager modules
    extraSpecialArgs = {inherit inputs;};
    # Use packages configured by NixOS configuration (overlays & allowUnfree)
    useGlobalPkgs = true;
    users.marshall = {
      imports = [../home];
      home.stateVersion = "22.05";
    };
  };

  systemd = {
    user.services.pipewire-pulse.path = [pkgs.pulseaudio];
    services.ssh-agent = {
      enable = true;
      description = "SSH key agent";
      serviceConfig = {
        Type = "simple";
        Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
        ExecStart = "/run/current-system/sw/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
      };
      wantedBy = ["multi-user.target"];
    };
  };

  users.users.marshall = {
    isNormalUser = true;
    home = "/home/marshall";
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFA12eoS+C+n1Pa1XaygSmx4+CGkO6oYV5bZeSeBU28Y mars@possums.xyz"
    ];
  };

  system.activationScripts = {
    fixVsCodeWriteAsSudo = {
      text = ''
        mkdir -m 0755 -p /bin
        ln -sf "/run/current-system/sw/bin/bash" /bin/.bash.tmp
        mv /bin/.bash.tmp /bin/bash
        ln -sf "/run/wrappers/bin/pkexec" /usr/bin/.pkexec.tmp
        mv /usr/bin/.pkexec.tmp /usr/bin/pkexec
        eval $(/run/current-system/sw/bin/ssh-agent)
      '';
      deps = [];
    };
  };

  time.timeZone = "America/New_York";
  security.sudo.wheelNeedsPassword = false;
  programs.dconf.enable = true;
  programs.steam.enable = true;
  programs.command-not-found.enable = false;
  environment.pathsToLink = [
    "/share/zsh"
  ];
}
