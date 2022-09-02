{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./dotfiles.nix
    ../pkgs/neovim.nix
    inputs.nixvim.homeManagerModules.nixvim
    inputs.nix-doom-emacs.hmModule
  ];

  home.packages = with pkgs; [
    # NIX-ADD BEGIN
    acpi
    alejandra
    android-tools
    appflowy
    audacity
    authy
    bacon
    bandwhich
    binutils
    brightnessctl
    cachix
    cargo-edit
    cargo-udeps
    cht-sh
    cmake
    comma
    ddcutil
    deno
    draconis
    fenix.complete.cargo
    fenix.complete.clippy
    fenix.complete.miri
    fenix.complete.rust-src
    fenix.complete.rustc
    fenix.complete.rustfmt
    file
    firefox-nightly-bin
    fleet
    fractal-next
    gcc
    glib
    gnome.eog
    gnome.geary
    gnome.nautilus
    gnome.seahorse
    gnumake
    gotktrix
    gparted
    gpick
    grex
    grim
    gsettings-desktop-schemas
    headsetcontrol
    helix
    hyper
    inotifyTools
    jamesdsp
    jellyfin-ffmpeg
    jetbrains.idea-ultimate
    jq
    keybase
    keychain
    kotatogram-desktop
    libappindicator
    libffi
    libnotify
    libsForQt5.qtstyleplugin-kvantum
    lite-xl
    lua52Packages.lgi
    lxappearance
    mate.engrampa
    micro
    minecraft
    mpvScripts.mpris
    mullvad-vpn
    nerdfonts
    nextcloud-client
    ngrok
    nix-prefetch-scripts
    nodePackages.generator-code
    nodePackages.pnpm
    nodePackages.yo
    nodejs
    nospm
    notion-app-enhanced
    noto-fonts-cjk-sans
    obs-studio
    odin
    openal
    openjdk16-bootstrap
    p7zip
    pamixer
    papirus-icon-theme
    pavucontrol
    picom
    playerctl
    polymc
    pulseaudio
    python
    python310
    ranger
    rnix-lsp
    rofi
    rust-analyzer-nightly
    scons
    scrot
    slurp
    statix
    sumneko-lua-language-server
    swaybg
    swaynotificationcenter
    tealdeer
    unrar
    unzip
    usbimager
    waybar
    wf-recorder
    wineWowPackages.waylandFull
    wl-clipboard
    wl-color-picker
    xclip
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdotool
    xonsh
    yarn
    zscroll
    # NIX-ADD END

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

    (inputs.replugged-overlay.lib.makeDiscordPlugged {
      inherit pkgs;

      discord = pkgs.discord-canary.override {withOpenASAR = true;};

      plugins = {
        inherit (inputs) theme-toggler tiktok-tts spotify-modal hastebin better-codeblocks pronoundb chat-components vpc-spotimbed simple-discord-crypt holy-notes;
      };

      themes = {
        inherit (inputs) catppuccin horizontal-server-list lavender context-icons fluent-icons;
      };
    })
  ];

  programs = {
    direnv.enable = true;
    gitui.enable = true;
    gpg.enable = true;

    bat = {
      enable = true;
      config.theme = "catppuccin";

      themes = {
        catppuccin = builtins.readFile (pkgs.fetchFromGitHub
          {
            owner = "catppuccin";
            repo = "sublime-text";
            rev = "0b7ac201ce4ec7bac5e0063b9a7483ca99907bbf";
            sha256 = "1kn5v8g87r6pjzzij9p8j7z9afc6fj0n8drd24qyin8p1nrlifi1";
          }
          + "/Catppuccin.tmTheme");
      };
    };

    doom-emacs = {
      enable = false;
      doomPrivateDir = ../dotfiles/doom.d;
    };

    exa = {
      enable = true;
      enableAliases = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    mpv = {
      enable = true;

      scripts = with pkgs; [
        mpvScripts.mpris
      ];
    };

    vscode = with pkgs; {
      enable = true;
      package = vscode-fhs;
    };

    git = {
      enable = true;
      userName = "marsupialgutz";
      userEmail = "mars@possums.xyz";
      delta.enable = true;
      lfs.enable = true;

      signing = {
        signByDefault = true;
        key = "DB41891AE0A1ED4D";
      };

      aliases = {
        "pushall" = "!git remote | xargs -L1 git push";
      };
    };

    go = {
      enable = true;
      package = pkgs.go_1_18;
    };

    kitty = {
      enable = true;

      font = {
        name = "Comic Code Ligatures";
        size = 12;
      };

      settings = {
        editor = "nvim";
        placement_strategy = "center";
        hide_window_decorations = "titlebar-only";
        background_opacity = "0.8";
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
        adjust_line_height = 3;
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

    navi = {
      enable = true;
      enableZshIntegration = true;
    };

    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd" "cd"];
    };

    zsh = {
      enable = true;
      dotDir = ".config/zsh";

      initExtraFirst = ''
        source ~/.cache/p10k-instant-prompt-marshall.zsh
        fpath+=~/.zfunc
      '';

      shellAliases = {
        se = "sudoedit";
        gc = "git commit";
        ga = "git add .";
        gcap = "ga; gc; git pushall";
        cat = "bat";
      };

      initExtra = ''
        my-backward-delete-word () {
            local WORDCHARS='~!#$%^&*(){}[]<>?+;'
            zle backward-delete-word
        }
        zle -N my-backward-delete-word

        bindkey -e
        bindkey "^[^?" my-backward-delete-word
        bindkey "^[[H" beginning-of-line
        bindkey "^[[F" end-of-line
        bindkey '^[[1;5C' emacs-forward-word
        bindkey '^[[1;5D' emacs-backward-word
        bindkey '^[[A' up-line-or-search
        bindkey '^[[B' down-line-or-search

        export PATH="$PATH:/home/marshall/.local/bin:/home/marshall/.cargo/bin:/home/marshall/go/bin:/home/marshall/.npm-packages/bin"
        export NODE_PATH="/home/marshall/.npm-packages/lib/node_modules"
        export EDITOR=nvim
        export VISUAL=nvim
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
          {name = "chisui/zsh-nix-shell";}
          {
            name = "romkatv/powerlevel10k";
            tags = ["as:theme" "depth:1"];
          }
          {
            name = "plugins/git";
            tags = ["from:oh-my-zsh"];
          }
        ];
      };
    };
  };

  services = {
    mpris-proxy.enable = true;

    gpg-agent = {
      enable = true;
      enableZshIntegration = true;
      pinentryFlavor = "gnome3";
    };
  };

  xdg.desktopEntries."idea-ultimate" = {
    name = "Intellij IDEA";
    exec = "steam-run idea-ultimate";
    icon = "idea-ultimate";
    settings.StartupWMClass = "jetbrains-idea";
  };

  wayland.windowManager.sway = {
    enable = false;
    extraOptions = ["--unsupported-gpu"];

    wrapperFeatures = {
      base = true;
      gtk = true;
    };
  };
}
