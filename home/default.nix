{
  inputs,
  pkgs,
  config,
  spicetify-nix,
  nix-init,
  hyprland-contrib,
  xdg-hyprland,
  self,
  ...
}:
with pkgs; {
  imports = [
    ./dotfiles.nix
    ../pkgs/nixvim.nix
    ../pkgs/nushell.nix
    ../pkgs/vscode.nix
    inputs.doom-emacs.hmModule
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

    packages =
      [
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
        carapace
        cargo-edit
        cargo-udeps
        cava
        cmake
        comma
        cozette
        curlie
        deno
        discord-plugged
        draconis
        edgedb
        file
        gcc
        gh
        gitoxide
        gjs
        gleam
        glib
        glrnvim
        gnome-extension-manager
        gnome.gnome-session
        gnumake
        gopls
        gpick
        grex
        grim
        gsettings-desktop-schemas
        headsetcontrol
        httpie-desktop
        hyprland-contrib.packages.${pkgs.system}.grimblast
        hyprpaper
        igrep
        inotify-tools
        insomnia
        ispell
        jamesdsp
        jetbrains-fleet
        jq
        keybase
        keychain
        kotatogram-desktop
        lazygit
        libappindicator
        libffi
        libgda6
        libnotify
        lucky-commit
        lxappearance
        micro
        microsoft-edge-dev
        minecraft
        mold
        mullvad-vpn
        mysql
        neovide
        ngrok
        nix-init.packages.${pkgs.system}.default
        nix-prefetch-scripts
        nix-snow
        nodejs-19_x
        notion-app-enhanced
        nurl
        obsidian
        odin
        openal
        p7zip
        pavucontrol
        playerctl
        prismlauncher
        pscale
        pulseaudio
        python312
        qmk
        revolt
        riff
        rnix-lsp
        rofi-wayland
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
        sx
        tealdeer
        tre
        unrar
        unzip
        via
        waybar
        wf-recorder
        wget
        wineWowPackages.waylandFull
        wl-clipboard
        wl-color-picker
        xclip
        xdg-hyprland.packages.${pkgs.system}.hyprland-share-picker
        xorg.xinit
        yarn
        zls
        zscroll
        # SNOW END
      ]
      ++ (with gnome; [
        dconf-editor
        eog
        file-roller
        gnome-tweaks
        nautilus
        seahorse
        zenity
      ])
      ++ (with gnomeExtensions; [
        arcmenu
        blur-my-shell
        browser-tabs
        burn-my-windows
        emoji-selector
        gnome-40-ui-improvements
        gsconnect
        just-perfection
        mpris-label
        no-overview
        openweather
        pano
        pop-shell
        rounded-window-corners
        space-bar
        tray-icons-reloaded
        vitals
      ])
      ++ (with nodePackages_latest; [
        eslint
        generator-code
        pnpm
        prettier
        typescript
        typescript-language-server
      ]);

    sessionVariables = {
      CLUTTER_BACKEND = "wayland";
      DEFAULT_BROWSER = "${pkgs.microsoft-edge-dev}/bin/microsoft-edge-dev";
      DIRENV_LOG_FORMAT = "";
      DISABLE_QT5_COMPAT = "0";
      EMACS_PATH_COPILOT = "${pkgs.fetchFromGitHub {
        owner = "zerolfx";
        repo = "copilot.el";
        rev = "05ffaddc5025d0d4e2424213f4989fc1a636ee31";
        hash = "sha256-K51HH8/ZkXXzmxCFqxsWn+o2hR3IPejkfQv7vgWBArQ=";
      }}";
      GBM_BACKEND = "nvidia-drm";
      GDK_BACKEND = "wayland";
      GDK_SCALE = "2";
      GLFW_IM_MODULE = "ibus";
      GPG_TTY = "$TTY";
      HOME_MANAGER_BACKUP_EXT = "bkp";
      LIBSEAT_BACKEND = "logind";
      LIBVA_DRIVER_NAME = "nvidia";
      NIXOS_OZONE_WL = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      WLR_BACKEND = "vulkan";
      WLR_DRM_NO_ATOMIC = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER = "vulkan";
      XCURSOR_SIZE = "48";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };

  programs = with pkgs; {
    direnv.enable = true;
    fzf.enable = true;
    gpg.enable = true;
    nix-index.enable = true;

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

    doom-emacs = {
      enable = true;
      doomPrivateDir = "${self}/dotfiles/emacs";

      emacsPackagesOverlay = self: super: {
        copilot-el = self.trivialBuild {
          pname = "copilot";
          ename = "copilot";
          version = "unstable";
          src = self.fetchFromGitHub {
            owner = "zerolfx";
            repo = "copilot.el";
            rev = "05ffaddc5025d0d4e2424213f4989fc1a636ee31";
            hash = "sha256-K51HH8/ZkXXzmxCFqxsWn+o2hR3IPejkfQv7vgWBArQ=";
          };
          buildInputs = [self.pkgs.nodejs];
        };
      };
    };

    exa = {
      enable = true;
      enableAliases = true;
    };

    firefox = {
      enable = false;
      package = firefox-nightly-bin.override {
        cfg = {
          enableGnomeExtensions = true;
        };
      };

      extensions = with firefox-addons; [
        absolute-enable-right-click
        active-forks
        betterviewer
        buster-captcha-solver
        catppuccin-mocha-sky
        clearurls
        darkreader
        disconnect
        don-t-fuck-with-paste
        hyperchat
        istilldontcareaboutcookies
        mpris-integration
        new-tab-override
        pinunpin-tab
        pronoundb
        react-devtools
        return-youtube-dislikes
        sponsorblock
        svg-export
        ttv-lol
        twitch-points-autoclicker
        ublock-origin
        unpaywall
        vimium-ff
        violentmonkey
        webnowplaying-companion
        youtube-addon
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
          };
        };
      };
    };

    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "pupbrained";
      userEmail = "mars@pupbrained.xyz";

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

      languages = [
        {
          name = "rust";
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }
      ];

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
        size = 14;
      };

      settings = {
        editor = "nvim";
        shell_integration = true;
        confirm_os_window_close = 0;
        allow_remote_control = "socket-only";
        listen_on = "unix:/tmp/kitty";
        placement_strategy = "center";
        hide_window_decorations = "yes";
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

    zoxide = {
      enable = true;
      options = ["--cmd" "cd"];
    };
  };

  services = {
    kbfs.enable = true;
    keybase.enable = true;
    mpris-proxy.enable = true;

    gpg-agent = {
      enable = true;
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
        "text/html" = "microsoft-edge-dev.desktop";
        "text/plain" = "nvim.desktop";
        "x-scheme-handler/about" = "microsoft-edge-dev.desktop";
        "x-scheme-handler/http" = "microsoft-edge-dev.desktop";
        "x-scheme-handler/https" = "microsoft-edge-dev.desktop";
        "x-scheme-handler/pie" = "httpie.desktop";
        "x-scheme-handler/unknown" = "microsoft-edge-dev.desktop";
        "x-scheme-handler/vscode-insiders" = "code-insiders.desktop";
        "x-www-browser" = "microsoft-edge-dev.desktop";
        "video/mp4" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/H264" = "mpv.desktop";
      };
    };
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.catppuccin-gtk.override {
        tweaks = ["rimless"];
        accents = ["green"];
        variant = "mocha";
      };
      name = "Catppuccin-Mocha-Standard-Sky-Dark";
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
    nvidiaPatches = true;
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
