{
  inputs,
  pkgs,
  ...
}: let
  sources = pkgs.callPackage ../_sources/generated.nix {};
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      config="$HOME/.config/gtk-3.0/settings.ini"
      gnome_schema=org.gnome.desktop.interface
      gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
      gsettings set "$gnome_schema" gtk-theme "$gtk_theme"
      gsettings set "$gnome_schema" icon-theme "$icon_theme"
      gsettings set "$gnome_schema" cursor-theme "$cursor_theme"
      gsettings set "$gnome_schema" font-name "$font_name"
    '';
  };
in {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (self: super: {
      inherit (inputs.vscodeInsiders.packages.${super.system}) vscodeInsiders;
      inherit (inputs.flake-firefox-nightly.packages.${super.system}) firefox-nightly-bin;
      draconis = inputs.draconis.defaultPackage.${super.system};
      discord = super.discord.override {
        withOpenASAR = true;
      };
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      });
    })
    inputs.powercord-overlay.overlay
    inputs.nur.overlay
    inputs.neovim-nightly-overlay.overlay
    inputs.fenix.overlay
    inputs.nixpkgs-wayland.overlay
    (import ../pkgs inputs)
  ];

  environment.systemPackages = with pkgs; [
    configure-gtk
  ];

  nix = {
    package = pkgs.nixFlakes;
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
    };

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
