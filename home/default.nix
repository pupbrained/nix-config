{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [./dotfiles.nix];
  home.packages = with pkgs; [
    acpi
    alejandra
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
      plugins = with inputs; [theme-toggler powercord-tiktok-tts];
      themes = with inputs; [lavender-discord catppuccin horizontal-server-list sur-cord];
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
        export NIXPKGS_ALLOW_UNFREE=1

        draconis
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';
      zplug = {
        enable = true;
        plugins = [
          {name = "zsh-users/zsh-autosuggestions";}
          {name = "zsh-users/zsh-syntax-highlighting";}
          {name = "zsh-users/zsh-history-substring-search";}
          {name = "RitchieS/zsh-exa";}
          {name = "chisui/zsh-nix-shell";}
          {
            name = "romkatv/powerlevel10k";
            tags = [as:theme depth:1];
          }
          {
            name = "plugins/git";
            tags = [from:oh-my-zsh];
          }
        ];
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd" "cd"];
    };

    kitty = {
      enable = true;
      font = {
        name = "Rec Mono Casual";
        size = 12;
      };
      settings = {
        editor = "nvim";
        placement_strategy = "center";
        hide_window_decorations = "titlebar-only";
        background_opacity = "0.95";
        inactive_text_alpha = 1;
        scrollback_lines = 5000;
        wheel_scroll_multiplier = 5;
        touch_scroll_multiplier = 1;
        tab_bar_min_tabs = 1;
        tab_bar_edge = "bottom";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = "{index} - {title}";
        cursor_shape = "beam";
        active_tab_font_style = "bold";
        inactive_tab_font_style = "normal";
        adjust_line_height = 5;
        adjust_column_width = 0;
        foreground = "#CDD6F4";
        background = "#1E1E2E";
        selection_foreground = "#1E1E2E";
        selection_background = "#F5E0DC";
        cursor = "#F5E0DC";
        cursor_text_color = "#1E1E2E";
        url_color = "#B4BEFE";
        active_border_color = "#CBA6F7";
        inactive_border_color = "#8E95B3";
        bell_border_color = "#EBA0AC";
        active_tab_foreground = "#11111B";
        active_tab_background = "#CBA6F7";
        inactive_tab_foreground = "#CDD6F4";
        inactive_tab_background = "#181825";
        tab_bar_background = "#11111B";
        mark1_foreground = "#1E1E2E";
        mark1_background = "#87B0F9";
        mark2_foreground = "#1E1E2E";
        mark2_background = "#CBA6F7";
        mark3_foreground = "#1E1E2E";
        mark3_background = "#74C7EC";
        color0 = "#45475A";
        color8 = "#45475A";
        color1 = "#F38BA8";
        color9 = "#F38BA8";
        color2 = "#A6E3A1";
        color10 = "#A6E3A1";
        color3 = "#F9E2AF";
        color11 = "#F9E2AF";
        color4 = "#89B4FA";
        color12 = "#89B4FA";
        color5 = "#F5C2E7";
        color13 = "#F5C2E7";
        color6 = "#94E2D5";
        color14 = "#94E2D5";
        color7 = "#BAC2DE";
        color15 = "#BAC2DE";
      };
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

      shadowExclude = ["bounding_shaped && !rounded_corners"];

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
