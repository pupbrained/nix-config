{ inputs, pkgs, config, ... }: {
  home.packages = with pkgs; [
    pkgs.nur.repos.marsupialgutz.draconis
    firefox-nightly-bin
    acpi
    audacity
    binutils
    brightnessctl
    busybox
    cargo-binutils
    cinnamon.nemo
    cmake
    exa
    feh
    ffmpeg
    file
    fluffychat
    gcc
    gh
    gnome.eog
    gnome.seahorse
    gnumake
    gpick
    headsetcontrol
    herbe
    inotifyTools
    jamesdsp
    jq
    keychain
    kitty
    kotatogram-desktop
    libnotify
    libsForQt5.qtstyleplugin-kvantum
    lua52Packages.lgi
    lxappearance
    mate.engrampa
    micro
    minecraft
    neovide
    neovim-nightly
    nerdfonts
    nixfmt
    nix-prefetch-scripts
    nodejs
    notion-app-enhanced
    noto-fonts-cjk-sans
    p7zip
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
    themechanger
    unrar
    unzip
    upower
    wineWowPackages.full
    xclip
    xdotool
    yarn

    (pkgs.discord-plugged.override {
      plugins = with inputs; [ theme-toggler powercord-tiktok-tts ];
      themes = with inputs; [ lavender-discord catppuccin horizontal-server-list sur-cord ];
    })
  ];

  programs = {
    gpg.enable = true;
    nix-index.enable = true;

    vscode = with pkgs; {
      enable = true;
      package = vscodeInsiders;
    };
    git = {
      enable = true;
      userName = "marsupialgutz";
      userEmail = "mars@possums.xyz";
    };
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      initExtraFirst = ''
        source ~/.cache/p10k-instant-prompt-marshall.zsh
      '';
      shellAliases = {
        se = "sudoedit";
        gc = "git commit";
        ga = "git add .";
      };
      initExtra = ''
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
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd" "cd" ];
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      pinentryFlavor = "tty";
    };
    picom = {
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
  };

}
