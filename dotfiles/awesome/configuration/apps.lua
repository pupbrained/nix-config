local filesystem = require("gears.filesystem")
local config_dir = filesystem.get_configuration_dir()
local utils_dir = config_dir .. "utilities/"

return {
  -- Default Applications
  default = {
    -- Default terminal emulator
    terminal = "kitty",
    -- Default music client
    music_player = "kitty --class music -e ncmpcpp",
    -- Default text editor
    text_editor = "neovide --neovim-bin /home/marshall/.local/bin/lvim",
    -- Default code editor
    code_editor = "code-insiders",
    -- Default web browser
    web_browser = "firefox",
    -- Default file manager
    file_manager = "nemo",
    -- Default network manager
    network_manager = "kitty -e nmtui",
    -- Default rofi global menu
    -- app_launcher = "rofi -no-lazy-grab -show drun -modi drun -theme " .. config_dir .. "configuration/rofi.rasi",
    app_launcher = "rofi -show drun"
  },

  -- List of apps to start once on start-up
  run_on_start_up = {
    -- Compositor
    "picom -b --experimental-backends --config " .. config_dir .. "/configuration/picom.conf",
    -- Network Manager applet
    "nm-applet",
    -- Resolution
    "xrandr --output DP-0 --mode 1920x1080 --rate 144",
  },

  -- List of binaries/shell scripts that will execute for a certain task
  utils = {
    -- Fullscreen screenshot
    full_screenshot = "/home/marshall/.config/rofi/scripts/screenshot.sh",
    -- Color Picker
    color_picker = config_dir .. "utilities/xcolor-pick",
  },
}
