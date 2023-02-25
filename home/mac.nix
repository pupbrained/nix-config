{
  inputs,
  pkgs,
  config,
  ...
}:
with pkgs; {
  imports = with inputs; [
    ../pkgs/nixvim.nix
    ../pkgs/bat.nix
    ../pkgs/vscode.nix
    nixvim.homeManagerModules.nixvim
    doom-emacs.hmModule
  ];

  nix = {
    registry = lib.mapAttrs (_: v: {flake = v;}) inputs;

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      max-jobs = "auto";
      flake-registry = "/etc/nix/registry.json";
      keep-derivations = true;
      keep-outputs = true;
      warn-dirty = false;

      trusted-users = ["marshall"];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      extra-sandbox-paths = /nix/var/cache/ccache
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };

  home.packages = [
    alejandra
    comma
    ripgrep
    fd
    nurl
    statix
  ];

  programs = {
    direnv.enable = true;
    fzf.enable = true;
    gpg.enable = true;
    nix-index.enable = true;

    exa = {
      enable = true;
      enableAliases = true;
    };

    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "pupbrained";
      userEmail = "mars@pupbrained.xyz";

      signing = {
        signByDefault = true;
        key = "874E22DF2F9DFCB5";
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
      package = pkgs.go_1_20;
    };

    java = {
      enable = true;
      package = pkgs.jdk;
    };

    kitty = {
      enable = true;

      font = {
        name = "Cartograph CF";
        size = 14;
      };

      extraConfig = ''
        modify_font cell_height -5px
        modify_font baseline 1.5
      '';

      settings = {
        editor = "nvim";
        shell_integration = true;
        confirm_os_window_close = 0;
        allow_remote_control = "socket-only";
        placement_strategy = "center";
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
        url_color = "#F5E0DC";
        active_border_color = "#B4BEFE";
        inactive_border_color = "#6C7086";
        bell_border_color = "#F9E2AF";
        wayland_titlebar_color = "system";
        macos_titlebar_color = "background";
        active_tab_foreground = "#11111B";
        active_tab_background = "#CBA6F7";
        inactive_tab_foreground = "#CDD6F4";
        inactive_tab_background = "#181825";
        tab_bar_background = "#11111B";
        mark1_foreground = "#1E1E2E";
        mark1_background = "#B4BEFE";
        mark2_foreground = "#1E1E2E";
        mark2_background = "#CBA6F7";
        mark3_foreground = "#1E1E2E";
        mark3_background = "#74C7EC";
        color0 = "#45475A";
        color8 = "#585B70";
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
        color15 = "#A6ADC8";
      };
    };

    zoxide = {
      enable = true;
      options = ["--cmd" "cd"];
    };
  };

  home.stateVersion = "23.05";
}
