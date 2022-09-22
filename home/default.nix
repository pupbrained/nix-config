{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./dotfiles.nix
    ../pkgs/neovim/default.nix
    inputs.nix-doom-emacs.hmModule
    inputs.spicetify-nix.homeManagerModule
  ];

  home.packages = with pkgs; [
    # SNOW BEGIN
    acpi
    alejandra
    android-tools
    audacity
    authy
    bacon
    bandwhich
    binutils
    brightnessctl
    btop
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
    jetbrains.webstorm
    jq
    keybase
    keychain
    kotatogram-desktop
    libappindicator
    libffi
    libnotify
    libsForQt5.qtstyleplugin-kvantum
    lite-xl
    llvmPackages_rocm.llvm.out
    lua52Packages.lgi
    lxappearance
    mate.engrampa
    micro
    minecraft
    mold
    mpvScripts.mpris
    mullvad-vpn
    nerdfonts
    nextcloud-client
    ngrok
    nix-prefetch-scripts
    nix-snow
    nix-software-center
    nixos-conf-editor
    nodePackages.generator-code
    nodePackages.pnpm
    nodePackages.yo
    nodejs
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
    premid
    pulseaudio
    python
    python310
    ranger
    revolt
    riff
    rnix-lsp
    rofi
    rust-analyzer-nightly
    scons
    scrot
    slurp
    sony-headphones-client
    statix
    sumneko-lua-language-server
    swaybg
    swaynotificationcenter
    tealdeer
    thefuck
    tre
    unrar
    unzip
    usbimager
    waybar
    wf-recorder
    wget
    wineWowPackages.waylandFull
    wl-clipboard
    wl-color-picker
    xclip
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdotool
    xonsh
    yarn
    zee
    zscroll
    # SNOW END

    (inputs.replugged-overlay.lib.makeDiscordPlugged {
      inherit pkgs;

      discord = pkgs.discord-canary.override {
        version = "0.0.139";
        src = fetchurl {
          url = "https://dl-canary.discordapp.net/apps/linux/0.0.139/discord-canary-0.0.139.tar.gz";
          sha256 = "sha256-/PfO0TWRxMrK+V1XkYmdaXQ6SfyJNBFETaR9oV90itI=";
        };
        withOpenASAR = true;
      };

      plugins = {
        inherit (inputs) theme-toggler tiktok-tts spotify-modal hastebin better-codeblocks pronoundb chat-components vpc-spotimbed simple-discord-crypt holy-notes cc-plugins;
      };

      themes = {
        inherit (inputs) catppuccin horizontal-server-list lavender context-icons fluent-icons termful;
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

    fish = {
      enable = true;

      interactiveShellInit = ''
        ${pkgs.thefuck}/bin/thefuck --alias tf | source
      '';

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
        ga = "git add .";
        gcap = "ga; gc; git pushall";
        cat = "bat";
      };

      shellInit = ''
        export PATH="$PATH:/home/marshall/.local/bin:/home/marshall/.cargo/bin:/home/marshall/go/bin:/home/marshall/.npm-packages/bin"
        export NODE_PATH="/home/marshall/.npm-packages/lib/node_modules"
        export EDITOR=nvim
        export VISUAL=nvim
        export NIXPKGS_ALLOW_UNFREE=1
      '';
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
    };

    mpv = {
      enable = true;

      scripts = with pkgs; [
        mpvScripts.mpris
      ];
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
        name = "Monocraft";
        size = 12;
      };

      settings = {
        editor = "nvim";
        shell_integration = true;
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
      enableFishIntegration = true;
    };

    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    spicetify = {
      enable = true;

      theme = "catppuccin-mocha";
      colorScheme = "mauve";

      enabledExtensions = [
        "fullAppDisplay.js"
        "shuffle+.js"
        "hidePodcasts.js"
      ];
    };

    vscode = with pkgs; {
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

  xdg.desktopEntries."idea-ultimate" = {
    name = "Intellij IDEA";
    exec = "steam-run idea-ultimate";
    icon = "idea-ultimate";
    settings.StartupWMClass = "jetbrains-idea";
  };

  systemd.user.services.polkit = {
    Unit = {
      Description = "A dbus session bus service that is used to bring up authentication dialogs";
      Documentation = ["man:polkit(8)"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      RestartSec = 5;
      Restart = "always";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
