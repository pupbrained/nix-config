{ inputs, pkgs, config, ... }: {
  home.packages = with pkgs; [
    pkgs.nur.repos.marsupialgutz.draconis
    firefox-nightly-bin
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
    exa
    feh
    ffmpeg
    file
    fluffychat
    gcc
    gh
    gnomeExtensions.appindicator
    gnomeExtensions.pop-shell
    gnome.gnome-tweaks
    gnome.seahorse
    gnumake
    gpick
    headsetcontrol
    inotifyTools.out
    jamesdsp
    jq
    keychain
    killall
    kitty
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
    neovim-nightly
    nerdfonts
    nixfmt
    nix-index
    nix-prefetch-scripts
    nodejs
    notion-app-enhanced
    noto-fonts-cjk-sans
    pamixer
    papirus-icon-theme
    pavucontrol
    playerctl
    polymc
    python
    python310
    redshift
    rofi
    rustup
    rust-analyzer
    scrot
    spicetify-cli
    spot
    steam
    sumneko-lua-language-server
    unrar
    unzip
    upower
    wineWowPackages.full
    xclip
    xdotool
    yarn

    (pkgs.discord-plugged.override {
      plugins = with inputs; [ theme-toggler powercord-tiktok-tts ];
      themes = with inputs; [ lavender-discord catppuccin ];
    })
  ];

  programs.vscode = with pkgs; {
    enable = true;
    package = vscodeInsiders;
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    pinentryFlavor = "tty";
  };

  programs.git = {
    enable = true;
    userName = "marsupialgutz";
    userEmail = "mars@possums.xyz";
    signing = {
      key = null;
      signByDefault = true;
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    initExtraFirst = ''
      source ~/.cache/p10k-instant-prompt-marshall.zsh
    '';
    shellAliases = {
      se = "sudoedit";
      gc = "git commit -S";
    };
    initExtra = ''
      source /nix/store/z3d56ipbv9ibsba0fn0fb1jna20yw5rk-nix-index-unstable-2022-03-07/etc/profile.d/command-not-found.sh

      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line
      bindkey '^[[1;5C' emacs-forward-word
      bindkey '^[[1;5D' emacs-backward-word
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      
      export PATH="$PATH:/home/marshall/.local/bin:/home/marshall/.cargo/bin"
      export EDITOR=lvim
      export VISUAL=lvim
      export GPG_TTY=$(tty)

      run() {
        nix-shell -p $1 --run \'$1\'
      }

      compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION

      draconis
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "zsh-users/zsh-history-substring-search"; }
        { name = "RitchieS/zsh-exa"; }
        { name = "chisui/zsh-nix-shell"; }
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
        { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
      ];
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ];
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
}
