_: {
  programs.kitty = {
    enable = true;
    shellIntegration.mode = "enabled";
    theme = "Catppuccin-Mocha";

    font = {
      name = "Maple Mono SC NF";
      size = 10;
    };

    extraConfig = ''
      font_features MapleMonoSCNF-Regular     +cv02 +cv03 +ss01 +ss02 +ss03 +ss04 +ss05
      font_features MapleMonoSCNF-Bold        +cv02 +cv03 +ss01 +ss02 +ss03 +ss04 +ss05
      font_features MapleMonoSCNF-BoldItalic  +cv02 +cv03 +ss01 +ss02 +ss03 +ss04 +ss05
      font_features MapleMonoSCNF-Italic      +cv02 +cv03 +ss01 +ss02 +ss03 +ss04 +ss05
      font_features MapleMonoSCNF-Light       +cv02 +cv03 +ss01 +ss02 +ss03 +ss04 +ss05
      font_features MapleMonoSCNF-LightItalic +cv02 +cv03 +ss01 +ss02 +ss03 +ss04 +ss05
    '';

    settings = {
      background_blur = 32;
      editor = "nvim";
      hide_window_decorations = "yes";
      background_opacity = "0.85";
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
    };
  };
}
