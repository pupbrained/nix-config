{pkgs, ...}: {
  services = {
    skhd = {
      enable = true;
      package = pkgs.skhd;

      skhdConfig = ''
        alt - return : open -na "Kitty" ~
        alt - w : open -na "Arc"
        # alt - d : scratchpad --toggle discord
        # alt - t : scratchpad --toggle telegram

        cmd - space : yabai -m window --toggle float

        shift + cmd - q : yabai -m window --close

        alt - h : yabai -m window --focus west
        alt - j : yabai -m window --focus south
        alt - k : yabai -m window --focus north
        alt - l : yabai -m window --focus east

        shift + cmd - h : yabai -m window --swap west
        shift + cmd - j : yabai -m window --swap south
        shift + cmd - k : yabai -m window --swap north
        shift + cmd - l : yabai -m window --swap east

        shift + cmd - 1 : yabai -m window --space 1
        shift + cmd - 2 : yabai -m window --space 2
        shift + cmd - 3 : yabai -m window --space 3
        shift + cmd - 4 : yabai -m window --space 4
        shift + cmd - 5 : yabai -m window --space 5
        shift + cmd - 6 : yabai -m window --space 6
        shift + cmd - 7 : yabai -m window --space 7
        shift + cmd - 8 : yabai -m window --space 8
        shift + cmd - 9 : yabai -m window --space 9
      '';
    };

    yabai = {
      enable = false;
      package = pkgs.yabai;

      config = {
        layout = "bsp";
        top_padding = 20;
        bottom_padding = 20;
        left_padding = 20;
        right_padding = 20;
        window_gap = 20;
        # focus_follows_mouse = "autoraise";
        # mouse_follows_focus = "off";
      };

      extraConfig = ''
        yabai -m rule --add app='^Emacs$' manage=on
        yabai -m rule --add title='Preferences' manage=off layer=above
        yabai -m rule --add title='^(Opening)' manage=off layer=above
        yabai -m rule --add title='Library' manage=off layer=above
        yabai -m rule --add app='^System Preferences$' manage=off layer=above
        yabai -m rule --add app='Activity Monitor' manage=off layer=above
        yabai -m rule --add app='^System Information$' manage=off layer=above
        yabai -m rule --add app='JetBrains Toolbox' manage=off layer=above
        yabai -m rule --add app='Mullvad VPN' manage=off layer=above
        yabai -m rule --add app='Google Assistant' manage=off layer=above
        yabai -m rule --add app='Fig' border=off
        yabai -m rule --add app='PsychEngine' border=off
      '';
    };
  };
}
