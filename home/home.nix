{ pkgs, ... }:

{
  home.username = "marshall";
  home.homeDirectory = "/home/marshall";
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    acpi
    acpid
    audacity
    binutils
    brightnessctl
    cargo-binutils
    chrome-gnome-shell
    cinnamon.nemo
    cmake
    dbus
    dbus.dev
    feh
    ffmpeg
    file
    gcc
    gh
    gnomeExtensions.appindicator
    gnomeExtensions.pop-shell
    gnome.gnome-tweaks
    gnome.seahorse
    gnumake
    gnupg
    gpick
    headsetcontrol
    jamesdsp
    jq
    keychain
    killall
    kotatogram-desktop
    libnotify
    lua52Packages.lgi
    lxappearance
    mate.engrampa
    micro
    minecraft
    mpd
    mpv
    ncmpcpp
    neovide
    nerdfonts
    nixfmt
    nix-prefetch-scripts
    nodejs
    noto-fonts-cjk-sans
    pamixer
    papirus-icon-theme
    pavucontrol
    playerctl
    polymc
    python
    python310
    redshift
    rustup
    rust-analyzer
    scrot
    spicetify-cli
    spot
    sumneko-lua-language-server
    unrar
    unzip
    upower
    uutils-coreutils
    vscode
    wineWowPackages.full
    xclip
    xdotool
    yarn
    zoxide
  ];

  programs.git = {
    enable = true;
    userName = "marsupialgutz";
    userEmail = "mars@possums.xyz";
  };

  services.picom = {
    enable = true;
    blur = true;
    extraOptions = ''
      blur-method = "dual_kawase";
      strength = 15;
    '';
    experimentalBackends = true;

    shadowExclude = [ "bounding_shaped && !rounded_corners" ];

    fade = true;
    fadeDelta = 7;
    vSync = true;
    opacityRule = [
      "100:class_g   *?= 'Chromium-browser'"
      "100:class_g   *?= 'Firefox'"
      "100:class_g   *?= 'gitkraken'"
      "100:class_g   *?= 'emacs'"
      "100:class_g   ~=  'jetbrains'"
      "100:class_g   *?= 'slack'"
    ];
    package = pkgs.picom.overrideAttrs (o: {
      src = pkgs.fetchFromGitHub {
        repo = "picom";
        owner = "ibhagwan";
        rev = "44b4970f70d6b23759a61a2b94d9bfb4351b41b1";
        sha256 = "0iff4bwpc00xbjad0m000midslgx12aihs33mdvfckr75r114ylh";
      };
    });
  };

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;
}
