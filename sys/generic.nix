{
  inputs,
  pkgs,
  ...
}: let
  sources = pkgs.callPackage ../_sources/generated.nix {};
in {
  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [(import ../pkgs inputs)];
  };

  nix = {
    package = pkgs.nixVersions.unstable;

    settings = {
      auto-optimise-store = true;
      warn-dirty = false;

      substituters = [
        "https://cache.nixos.org"
        "https://cache.nixos.org/"
        "https://statix.cachix.org"
        "https://nix-community.cachix.org"
        "https://helix.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "statix.cachix.org-1:Z9E/g1YjCjU117QOOt07OjhljCoRZddiAm4VVESvais="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      ];

      trusted-users = ["marshall"];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      extra-sandbox-paths = /nix/var/cache/ccache
    '';
  };

  systemd = {
    user.services.pipewire-pulse.path = [pkgs.pulseaudio];

    services = {
      openssh.enable = true;
      ssh-agent = {
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
  };

  users.users.marshall = {
    isNormalUser = true;
    home = "/home/marshall";
    shell = pkgs.nushell;

    extraGroups = [
      "asbusers"
      "i2c"
      "networkmanager"
      "wheel"
    ];

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

  programs = {
    ccache.enable = true;
    command-not-found.enable = false;
  };

  time.timeZone = "America/New_York";
  security.sudo.wheelNeedsPassword = false;
}
