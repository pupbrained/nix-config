{
  inputs,
  pkgs,
  config,
  spicetify-nix,
  hyprland-contrib,
  ...
}:
with pkgs; {
  imports = [
    ./dotfiles.nix
    ../pkgs/nixvim.nix
    ../pkgs/nushell.nix
    ../pkgs/espanso.nix
    inputs.spicetify-nix.homeManagerModule
    inputs.hyprland.homeManagerModules.default
    inputs.nur.nixosModules.nur
    inputs.nixvim.homeManagerModules.nixvim
  ];

  home = {
    file.".mozilla/firefox/marshall/chrome" = {
      source = ../dotfiles/firefox;
      recursive = true;
    };

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.catppuccin-cursors;
      name = "Catppuccin-Mocha-Dark-Cursors";
      size = 24;
    };

    packages = [
      # SNOW BEGIN
      acpi
      alejandra
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
      cozette
      curlie
      discord-plugged
      draconis
      edgedb
      file
      gcc
      gh
      gitoxide
      gleam
      glib
      glrnvim
      gnome.file-roller
      gnome.nautilus
      gnome.seahorse
      gnome.zenity
      gnumake
      gopls
      gpick
      gradience
      grex
      grim
      gsettings-desktop-schemas
      headsetcontrol
      httpie-desktop
      hyprland-contrib.packages.${pkgs.system}.grimblast
      inotify-tools
      insomnia
      jamesdsp
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
      lucky-commit
      lxappearance
      micro
      minecraft
      mold
      mullvad-vpn
      mysql
      neovide
      ngrok
      nix-prefetch-scripts
      nix-snow
      nodePackages.generator-code
      nodePackages.pnpm
      nodePackages.typescript-language-server
      nodejs-16_x # for copilot
      notion-app-enhanced
      nvui
      obsidian
      odin
      openal
      p7zip
      pavucontrol
      playerctl
      prismlauncher
      pscale
      pulseaudio
      python
      python310
      revolt
      riff
      rnix-lsp
      rofi
      rust-analyzer-nightly
      rustup
      sapling
      scrot
      slurp
      starfetch
      starship
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
      zls
      zscroll
      # SNOW END
    ];

    sessionVariables = {
      CLUTTER_BACKEND = "wayland";
      DEFAULT_BROWSER = "${pkgs.firefox-nightly-bin}/bin/firefox";
      DIRENV_LOG_FORMAT = "";
      DISABLE_QT5_COMPAT = "0";
      GBM_BACKEND = "nvidia-drm";
      GDK_BACKEND = "wayland";
      GLFW_IM_MODULE = "ibus";
      GPG_TTY = "$TTY";
      LIBSEAT_BACKEND = "logind";
      LIBVA_DRIVER_NAME = "nvidia";
      NIXOS_OZONE_WL = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_STYLE_OVERRIDE = "kvantum";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      WLR_BACKEND = "vulkan";
      WLR_DRM_NO_ATOMIC = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER = "vulkan";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };

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
        firefox-addons.betterviewer
        firefox-addons.buster-captcha-solver
        firefox-addons.catppuccin-mocha-sky
        firefox-addons.clearurls
        firefox-addons.disconnect
        firefox-addons.docsafterdark
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
        cat = "bat";
        ga = "git add";
        gap = "git add -p";
        gc = "git commit";
        gcap = "ga .; gc; git pushall";
        gcp = "gc; git pushall";
        gd = "git diff";
        gs = "git status";
        lg = "lazygit";
        ssh = "kitty +kitten ssh";
      };

      shellInit = ''
        string match -q "$TERM_PROGRAM" "vscode"
        and . (code-insiders --locate-shell-integration-path fish)
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

      extraConfig = {
        push.autoSetupRemote = true;
      };
    };

    go = {
      enable = true;
      package = pkgs.go_1_19;
    };

    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_mocha";
        editor = {
          line-number = "relative";
          cursorline = true;
          color-modes = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          indent-guides.render = true;
        };
      };
    };

    java = {
      enable = true;
      package = pkgs.jdk;
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
        confirm_os_window_close = 0;
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
        tab_bar_min_tabs = 2;
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
        color1 = "#F38BA8";
        color2 = "#A6E3A1";
        color3 = "#F9E2AF";
        color4 = "#89B4FA";
        color5 = "#F5C2E7";
        color6 = "#94E2D5";
        color7 = "#BAC2DE";
        color8 = "#45475A";
        color9 = "#F38BA8";
        color10 = "#A6E3A1";
        color11 = "#F9E2AF";
        color12 = "#89B4FA";
        color13 = "#F5C2E7";
        color14 = "#94E2D5";
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

    spicetify = let
      spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
    in {
      enable = true;
      theme = spicePkgs.themes.catppuccin-mocha;
      colorScheme = "sky";

      spotifyPackage = pkgs.spotify-unwrapped.overrideAttrs (o: {
        installPhase = o.installPhase + "wrapProgram $out/bin/spotify --prefix LD_PRELOAD : \"${pkgs.spotifywm-fixed}/lib/spotifywm.so\"";
      });

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplayMod
        shuffle
        hidePodcasts
        playNext
        volumePercentage
        genre
        history
        lastfm
        copyToClipboard
        showQueueDuration
        songStats
        fullAlbumDate
        keyboardShortcut
        powerBar
        playlistIcons
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
    kbfs.enable = true;
    keybase.enable = true;
    mpris-proxy.enable = true;

    espanso-m.enable = true;

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
        "application/x-ms-dos-executable" = "wine.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "image/png" = "gnome.org.eog.desktop";
        "image/jpeg" = "gnome.org.eog.desktop";
        "image/gif" = "gnome.org.eog.desktop";
        "image/webp" = "gnome.org.eog.desktop";
        "text/html" = "firefox.desktop";
        "text/plain" = "nvim.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/pie" = "httpie.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
        "x-scheme-handler/vscode-insiders" = "code-insiders.desktop";
        "x-www-browser" = "firefox.desktop";
        "video/mp4" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/H264" = "mpv.desktop";
      };
    };
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.catppuccin-gtk;
      name = "Catppuccin-Mocha-Mauve";
    };

    iconTheme = {
      package = pkgs.catppuccin-folders;
      name = "Papirus";
    };

    font = {
      name = "Google Sans Text";
      size = 11;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";

    style = {
      package = pkgs.adwaita-qt;
      name = "adwaita-dark";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland-nvidia;
    systemdIntegration = true;
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
