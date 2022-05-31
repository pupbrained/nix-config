# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.overlays = [
    (final: prev: {
      awesome = (prev.awesome.overrideAttrs (old: {
        src = prev.fetchFromGitHub {
          owner = "awesomeWM";
          repo = "awesome";
          rev = "c539e0e4350a42f813952fc28dd8490f42d934b3";
          sha256 = "10k1bkif7mqqhgwbvh0vi13gf1qgxszack3r0shmsdainm37hqz3";
        };
        patches = [ ];
        GI_TYPELIB_PATH = "${prev.playerctl}/lib/girepository-1.0:"
          + "${prev.upower}/lib/girepository-1.0:"
          + old.GI_TYPELIB_PATH;
      })).override {
        stdenv = prev.clangStdenv;
        gtk3Support = true;
      };
    })
    (self: super: {
      vscodeInsiders =
        inputs.vscodeInsiders.packages.${super.system}.vscodeInsiders;
      firefox-nightly-bin =
        inputs.flake-firefox-nightly.packages.${super.system}.firefox-nightly-bin;
    })
    inputs.powercord-overlay.overlay
    inputs.nur.overlay
    inputs.neovim-nightly-overlay.overlay
  ];

  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_testing;
    extraModprobeConfig = "options hid_apple fnmode=1";
  };

  networking = {
    hostName = "nix";
    useDHCP = false;
    networkmanager.enable = true;
  };

  services = {
    gnome.gnome-keyring.enable = true;
    flatpak.enable = true;
    xserver = {
      enable = true;

      displayManager = {
        gdm.enable = true;
        defaultSession = "none+awesome";
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-rounded;
        extraPackages = with pkgs; [ feh polybar i3lock ];
      };

      windowManager.awesome.enable = true;

      videoDrivers = [ "nvidia" ];
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };

  systemd = {
    user.services.pipewire-pulse.path = [ pkgs.pulseaudio ];
    services.ssh-agent = {
      enable = true;
      description = "SSH key agent";
      serviceConfig = {
        Type = "simple";
        Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
        ExecStart = "/run/current-system/sw/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };

  hardware = {
    nvidia.modesetting.enable = true;
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
  };

  users.extraUsers.marshall = {
    isNormalUser = true;
    home = "/home/marshall";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFA12eoS+C+n1Pa1XaygSmx4+CGkO6oYV5bZeSeBU28Y mars@possums.xyz"
    ];
  };

  home-manager = {
    # Pass inputs to all home-manager modules
    # Isn't used currently, but could be useful
    extraSpecialArgs = { inherit inputs; };
    # Use packages configured by NixOS configuration (overlays & allowUnfree)
    useGlobalPkgs = true;
    users.marshall = {
      imports = [ ../home ];
      home.stateVersion = "22.05";
    };
  };

  system.activationScripts = {
    fixVsCodeWriteAsSudo = {
      text = ''
        mkdir -m 0755 -p /bin
        # HACK: Get path dynamically
        ln -sf "/run/current-system/sw/bin/bash" /bin/.bash.tmp
        mv /bin/.bash.tmp /bin/bash # atomically replace it
        # HACK: Get path dynamically
        ln -sf "/run/wrappers/bin/pkexec" /usr/bin/.pkexec.tmp
        mv /usr/bin/.pkexec.tmp /usr/bin/pkexec # atomically replace it
        eval $(/run/current-system/sw/bin/ssh-agent)
      '';
      deps = [ ];
    };
  };

  time.timeZone = "America/New_York";
  xdg.portal.enable = true;
  nixpkgs.config.allowUnfree = true;
  security.sudo.wheelNeedsPassword = false;
  programs.dconf.enable = true;

  system.stateVersion = "21.11";
}
