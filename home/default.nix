{
  inputs,
  pkgs,
  config,
  ...
}:
with pkgs; {
  imports = [
    ./dotfiles.nix
    ../pkgs/neovim/default.nix
    inputs.nix-doom-emacs.hmModule
    inputs.spicetify-nix.homeManagerModule
    inputs.nur.nixosModules.nur
  ];

  home.file.".mozilla/firefox/marshall/chrome" = {
    source = ../dotfiles/firefox;
    recursive = true;
  };

  home.packages = [
    # SNOW BEGIN
    acpi
    alejandra
    android-tools
    audacity
    authy
    bacon
    binutils
    brightnessctl
    btop
    cachix
    cargo-edit
    cargo-udeps
    cava
    cmake
    comma
    discord-patched
    draconis
    edgedb
    file
    gcc
    glib
    glrnvim
    gnome.eog
    gnome.file-roller
    gnome.geary
    gnome.gnome-tweaks
    gnome.nautilus
    gnome.seahorse
    gnome.zenity
    gnumake
    gpick
    gradience
    grex
    grim
    gsettings-desktop-schemas
    headsetcontrol
    inotify-tools
    jamesdsp
    jellyfin-ffmpeg
    jetbrains-fleet
    jetbrains.idea-ultimate
    jetbrains.webstorm
    jq
    keybase
    keychain
    kotatogram-desktop
    lazygit
    libappindicator
    libffi
    libnotify
    libsForQt5.qtstyleplugin-kvantum
    lxappearance
    micro
    minecraft
    mold
    mpvScripts.mpris
    mullvad-vpn
    nextcloud-client
    ngrok
    nil
    nix-prefetch-scripts
    nix-snow
    nodePackages.generator-code
    nodePackages.pnpm
    nodePackages.typescript-language-server
    nodejs-16_x
    notion-app-enhanced
    nvui
    obs-studio
    odin
    openal
    openjdk16-bootstrap
    p7zip
    pavucontrol
    playerctl
    prismlauncher
    pulseaudio
    python
    python310
    revolt
    riff
    rnix-lsp
    rofi
    rust-analyzer-nightly
    rustup
    scrot
    slurp
    statix
    stylua
    sumneko-lua-language-server
    swaynotificationcenter
    tealdeer
    tre
    unrar
    unzip
    waybar
    wf-recorder
    wget
    wineWowPackages.waylandFull
    wl-clipboard
    wl-color-picker
    xclip
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    yarn
    zscroll
    # SNOW END
  ];

  programs = with pkgs; {
    direnv.enable = true;
    gpg.enable = true;

    bat = {
      enable = true;
      config.theme = "catppuccin";

      themes = {
        catppuccin = builtins.readFile (fetchFromGitHub
          {
            owner = "catppuccin";
            repo = "sublime-text";
            rev = "0b7ac201ce4ec7bac5e0063b9a7483ca99907bbf";
            sha256 = "1kn5v8g87r6pjzzij9p8j7z9afc6fj0n8drd24qyin8p1nrlifi1";
          }
          + "/Catppuccin.tmTheme");
      };
    };

    exa = {
      enable = true;
      enableAliases = true;
    };

    firefox = {
      enable = true;

      package = firefox-nightly-bin;

      extensions = with config.nur.repos.rycee.firefox-addons; [
        add-custom-search-engine
        adnauseam
        darkreader
        don-t-fuck-with-paste
        https-everywhere
        new-tab-override
        protondb-for-steam
        react-devtools
        return-youtube-dislikes
        sponsorblock
        to-deepl
        ublock-origin
        unpaywall
        vimium
        violentmonkey
        firefox-addons.absolute-enable-right-click
        firefox-addons.active-forks
        firefox-addons.adblock-for-youtube
        firefox-addons.betterviewer
        firefox-addons.buster-captcha-solver
        firefox-addons.catppuccin-mocha-sky
        firefox-addons.clearurls
        firefox-addons.disconnect
        firefox-addons.docsafterdark
        firefox-addons.font-fingerprint-defender
        firefox-addons.hyperchat
        firefox-addons.istilldontcareaboutcookies
        firefox-addons.mpris-integration
        firefox-addons.pinunpin-tab
        firefox-addons.pronoundb
        firefox-addons.svg-export
        firefox-addons.ttv-lol
        firefox-addons.twitch-points-autoclicker
        firefox-addons.webnowplaying-companion
        firefox-addons.youtube-addon
      ];

      profiles = {
        marshall = {
          settings = {
            "general.smoothScroll.currentVelocityWeighting" = "0.15";
            "general.smoothScroll.mouseWheel.durationMaxMS" = 250;
            "general.smoothScroll.mouseWheel.durationMinMS" = 250;
            "general.smoothScroll.msdPhysics.enabled" = true;
            "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 400;
            "general.smoothScroll.msdPhysics.regularSpringConstant" = 600;
            "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 120;
            "general.smoothScroll.other.durationMaxMS" = 500;
            "general.smoothScroll.pages.durationMaxMS" = 350;
            "general.smoothScroll.stopDecelerationWeighting" = "0.8";
            "gfx.webrender.all" = true;
            "svg.context-properties.content.enabled" = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "userChrome.FilledMenuIcons-Enabled" = true;
            "userChrome.OneLine-Enabled" = true;
            "userChrome.ProtonTabs-Enabled" = true;
          };
        };
      };
    };

    fish = {
      enable = true;

      plugins = [
        {
          name = "tide";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "73c7b469aa603e580e14eca21ab31abed49c6214";
            sha256 = "14h6x3q3lswivfwkm8b87lm1hcwim9jyygvrlm22la7ca1al5frm";
          };
        }
        {
          name = "catppuccin";
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "fish";
            rev = "cb79527f5bd53f103719649d34eff3fbae634155";
            sha256 = "062biq1pjqwp3qc506q2cczy5w7ysy4109p3c5x45m24nqk0s9bj";
          };
        }
      ];

      shellAliases = {
        se = "sudoedit";
        gc = "git commit";
        ga = "git add";
        gap = "git add -p";
        gcap = "ga .; gc; git pushall";
        gcp = "gc; git pushall";
        gs = "git status";
        gd = "git diff";
        cat = "bat";
      };

      shellInit = ''
        export PATH="$PATH:/home/marshall/.local/bin:/home/marshall/.cargo/bin:/home/marshall/go/bin:/home/marshall/.npm-packages/bin"
        export NODE_PATH="/home/marshall/.npm-packages/lib/node_modules"
        export EDITOR=nvim
        export VISUAL=nvim
      '';
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "pupbrained";
      userEmail = "mars@pupbrained.xyz";
      delta.enable = true;

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
      package = pkgs.go_1_19;
    };

    kitty = {
      enable = true;

      font = {
        name = "Maple Mono NF";
        size = 12;
      };

      settings = {
        editor = "nvim";
        shell_integration = true;
        allow_remote_control = "socket-only";
        listen_on = "unix:/tmp/kitty";
        placement_strategy = "center";
        hide_window_decorations = "titlebar-only";
        background_opacity = "0.8";
        dynamic_background_opacity = true;
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

    mpv = {
      enable = true;

      scripts = [
        mpvScripts.mpris
      ];
    };

    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    spicetify = {
      enable = true;
      theme = "catppuccin-mocha";
      colorScheme = "mauve";

      spotifyPackage = pkgs.spotify-unwrapped.overrideAttrs (o: {
        installPhase =
          o.installPhase
          + ''
            wrapProgram $out/bin/spotify --prefix LD_PRELOAD : "${pkgs.spotifywm-fixed}/lib/spotifywm.so"
          '';
      });

      enabledExtensions = [
        "fullAppDisplayMod.js"
        "shuffle+.js"
        "hidePodcasts.js"
        "playNext.js"
        "volumePercentage.js"
        "genre.js"
        "history.js"
        "lastfm.js"
        "copyToClipboard.js"
        "showQueueDuration.js"
        "songStats.js"
        "fullAlbumDate.js"
        "keyboardShortcut.js"
        "powerBar.js"
        "playlistIcons.js"
      ];
    };

    vscode = {
      enable = true;
      package = vscodeInsiders;
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = ["--cmd" "cd"];
    };
  };

  services = {
    mpris-proxy.enable = true;

    gpg-agent = {
      enable = true;
      enableFishIntegration = true;
      pinentryFlavor = "gnome3";
    };
  };

  xdg = {
    mimeApps = {
      enable = true;

      defaultApplications = {
        "image/png" = "eog.desktop";
        "image/jpeg" = "eog.desktop";
        "image/gif" = "eog.desktop";
        "image/webp" = "eog.desktop";
        "text/html" = "firefox.desktop";
        "text/plain" = "nvim.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
        "video/mp4" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/H264" = "mpv.desktop";
      };
    };

    desktopEntries."idea-ultimate" = {
      name = "Intellij IDEA";
      exec = "steam-run idea-ultimate";
      icon = "idea-ultimate";
      settings.StartupWMClass = "jetbrains-idea";
    };
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.catppuccin-gtk;
      name = "Catppuccin-Mocha-Mauve";
    };

    cursorTheme = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
    };

    iconTheme = {
      package = pkgs.kora-icon-theme;
      name = "kora";
    };

    font = {
      name = "Google Sans Text";
      size = 11;
    };
  };

  systemd.user.services.polkit = {
    Unit = {
      Description = "A dbus session bus service that is used to bring up authentication dialogs";
      Documentation = ["man:polkit(8)"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      RestartSec = 5;
      Restart = "always";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
