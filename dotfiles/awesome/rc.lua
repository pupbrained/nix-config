-- ░█▀▄░█░█░█░█░█░█░█▀█░▀░█▀▀░░░█▀█░█░█░█▀▀░█▀▀░█▀█░█▄█░█▀▀
-- ░█▀▄░▄▀▄░░█░░█▀█░█░█░░░▀▀█░░░█▀█░█▄█░█▀▀░▀▀█░█░█░█░█░█▀▀
-- ░▀░▀░▀░▀░░▀░░▀░▀░▀░▀░░░▀▀▀░░░▀░▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀
-- --------------------  @author rxyhn --------------------
-- --------------- https://github.com/rxyhn ---------------

pcall(require, "luarocks.loader")
local gears = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")
require("awful.autofocus")

-- ░▀█▀░█░█░█▀▀░█▄█░█▀▀
-- ░░█░░█▀█░█▀▀░█░█░█▀▀
-- ░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀

local theme_dir = gears.filesystem.get_configuration_dir() .. "theme/"
beautiful.init(theme_dir .. "theme.lua")
local nice = require("nice")
nice {
  titlebar_items = {
    left = { "close", "minimize", "maximize" },
    middle = "title",
  },
  titlebar_font = "Recursive Sans Casual Static 11",
  floating_color = "#00000000",
  ontop_color = "#00000000",
  sticky_color = "#00000000"
}

-- ░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀░█░█░█▀▄░█▀█░▀█▀░▀█▀░█▀█░█▀█░█▀▀
-- ░█░░░█░█░█░█░█▀▀░░█░░█░█░█░█░█▀▄░█▀█░░█░░░█░░█░█░█░█░▀▀█
-- ░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀░▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀

require("configuration")

-- ░█▄█░█▀█░█▀▄░█░█░█░░░█▀▀░█▀▀
-- ░█░█░█░█░█░█░█░█░█░░░█▀▀░▀▀█
-- ░▀░▀░▀▀▀░▀▀░░▀▀▀░▀▀▀░▀▀▀░▀▀▀

require("module")

-- ░█▀▄░█▀█░█▀▀░█▄█░█▀█░█▀█░█▀▀
-- ░█░█░█▀█░█▀▀░█░█░█░█░█░█░▀▀█
-- ░▀▀░░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀

require("signal")

-- ░█░█░▀█▀
-- ░█░█░░█░
-- ░▀▀▀░▀▀▀

require("ui")

-- ░█░█░█▀█░█░░░█░░░█▀█░█▀█░█▀█░█▀▀░█▀▄
-- ░█▄█░█▀█░█░░░█░░░█▀▀░█▀█░█▀▀░█▀▀░█▀▄
-- ░▀░▀░▀░▀░▀▀▀░▀▀▀░▀░░░▀░▀░▀░░░▀▀▀░▀░▀

awful.screen.connect_for_each_screen(function(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper

    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end

    gears.wallpaper.maximized(gears.surface.load_uncached(wallpaper), s, false, nil)
  end
end)

-- ░█▀▀░█▀█░█▀▄░█▀▄░█▀█░█▀▀░█▀▀
-- ░█░█░█▀█░█▀▄░█▀▄░█▀█░█░█░█▀▀
-- ░▀▀▀░▀░▀░▀░▀░▀▀░░▀░▀░▀▀▀░▀▀▀

-- Enable for lower memory consumption
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
