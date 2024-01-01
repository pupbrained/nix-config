{
  inputs,
  lib,
  pkgs,
  ...
}: {
  gtk = {
    enable = true;

    cursorTheme = {
      package = pkgs.catppuccin-cursors.mochaGreen;
      name = "Catppuccin-Mocha-Green-Cursors";
    };

    iconTheme = {
      package = pkgs.catppuccin-folders;
      name = "Papirus";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    plugins = [inputs.hycov.packages.${pkgs.system}.hycov];

    settings = {
      "$mod" = "SUPER";

      decoration.rounding = 10;
      input.sensitivity = -0.4;
      monitor = "DP-1, 2560x1440@165, auto, auto";

      bezier = [
        "linear  , 0.0 , 0.0, 1.0, 1.0"
        "overshot, 0.05, 0.9, 0.1, 1.05"
      ];

      animations.animation = [
        "border     , 1, 14 , default"
        "borderangle, 1, 100, linear  , loop"
        "windows    , 1, 5  , overshot, popin"
      ];

      exec-once = [
        # Notifications
        "swaync"
        # Status Bar
        "waybar"
        # Wallpaper
        "swww init"
        # Clipboard
        "wl-paste --type text  --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      general = {
        border_size = 2;

        "col.active_border" = with lib.strings;
          concatStrings [
            (concatMapStrings
              (x: x + " ")
              [
                "rgb(f5c2e7)" # Pink
                "rgb(cba6f7)" # Mauve
                "rgb(f38ba8)" # Red
                "rgb(eba0ac)" # Maroon
                "rgb(fab387)" # Peach
                "rgb(f9e2af)" # Yellow
                "rgb(a6e3a1)" # Green
                "rgb(74c7ec)" # Sapphire
                "rgb(89b4fa)" # Blue
                "rgb(b4befe)" # Lavendar
              ])
            "90deg"
          ];
      };

      bind =
        [
          # Window Management
          "$mod, f    , fullscreen"
          "$mod, p    , pseudo"
          "$mod, q    , killactive"
          "$mod, space, togglefloating"

          # Binds for quick-launching apps
          "$mod, return, exec, kitty"
          "$mod, r     , exec, wofi"
          "$mod, w     , exec, thorium"

          # Window Focus
          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"

          # Window Moving
          "$mod shift, h, movewindow, l"
          "$mod shift, j, movewindow, d"
          "$mod shift, k, movewindow, u"
          "$mod shift, l, movewindow, r"

          # Window Resizing
          "$mod alt, h, resizeactive, -50   0"
          "$mod alt, j, resizeactive,   0  50"
          "$mod alt, k, resizeactive,   0 -50"
          "$mod alt, l, resizeactive,  50   0"

          # Workspace Switching
          "$mod ctrl, h, workspace, e-1"
          "$mod ctrl, l, workspace, e+1"

          # Special Workspace
          "$mod      , x, togglespecialworkspace"
          "$mod shift, x, movetoworkspace, special"

          # Hycov
          "ctrl alt, h, hycov:enteroverview"
          "ctrl alt, m, hycov:leaveoverview"
          "ctrl alt, k, hycov:toggleoverview"
          "alt, h, hycov:movefocus, l"
          "alt, j, hycov:movefocus, d"
          "alt, k, hycov:movefocus, u"
          "alt, l, hycov:movefocus, r"
        ]
        ++ (
          # Sets up workspace binds from 1-10
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod      , ${ws}, workspace      , ${toString (x + 1)}"
                "$mod shift, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );

      bindm = [
        # Mouse binds for moving and resizing
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      plugin.hycov = {
        enable_hotarea = 0;
        overview_gappi = 24;
        overview_gappo = 60;
      };
    };
  };
}
