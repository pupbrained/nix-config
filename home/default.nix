{ inputs, pkgs, config, ... }: {
  imports = [ ./dotfiles.nix ];
  home.packages = with pkgs; [
    acpi
    android-tools
    audacity
    binutils
    brightnessctl
    busybox
    cargo-binutils
    cinnamon.nemo
    cmake
    draconis
    exa
    ffmpeg
    file
    firefox-nightly-bin
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
    jetbrains.idea-ultimate
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
    mpv
    neovide
    neovim-nightly
    nerdfonts
    nixfmt
    nix-prefetch-scripts
    nodejs
    notion-app-enhanced
    noto-fonts-cjk-sans
    openjdk16-bootstrap
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
    sumneko-lua-language-server
    themechanger
    unrar
    unzip
    upower
    wineWowPackages.full
    xclip
    xdotool
    yarn
    (spotify-spicetified.override {
      theme = "catppuccin";

      colorScheme = "mauve";

      injectCss = true;
      replaceColors = true;
      overwriteAssets = true;
      customExtensions = {
        "catppuccin.js" = "${catppuccin-spicetify}/catppuccin.js";
      };
      enabledExtensions = [
        "catppuccin.js"
      ];
    })
    (pkgs.discord-plugged.override {
      plugins = with inputs; [ theme-toggler powercord-tiktok-tts ];
      themes = with inputs; [ lavender-discord catppuccin horizontal-server-list sur-cord ];
    })
  ];

  programs = {
    direnv.enable = true;
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
      signing = {
        signByDefault = true;
        key = "DB41891AE0A1ED4D";
      };
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
        bindkey '^[[A' up-line-or-search
        bindkey '^[[B' down-line-or-search
      
        export PATH="$PATH:/home/marshall/.local/bin:/home/marshall/.cargo/bin"
        export EDITOR=lvim
        export VISUAL=lvim

        run() {
          nix-shell -p $1 --run \'$1\'
        }

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
      pinentryFlavor = "gnome3";
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
    };
  };

  xdg.desktopEntries."idea-ultimate" = {
    name = "Intellij IDEA";
    exec = "steam-run idea-ultimate";
    icon = "idea-ultimate";
    settings.StartupWMClass = "jetbrains-idea";
  };
}
