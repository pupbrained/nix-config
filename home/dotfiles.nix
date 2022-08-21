_: {
  xdg.configFile = {
    "awesome" = {
      source = ../dotfiles/awesome;
      recursive = true;
    };

    "lvim" = {
      source = ../dotfiles/lvim;
      recursive = true;
    };

    "micro".source = ../dotfiles/micro;
    "polybar".source = ../dotfiles/polybar;
    "rofi".source = ../dotfiles/rofi;
    "sway".source = ../dotfiles/sway;
    "waybar".source = ../dotfiles/waybar;
    "hypr".source = ../dotfiles/hypr;
  };
}
