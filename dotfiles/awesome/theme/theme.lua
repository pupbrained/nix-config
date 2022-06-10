-- ░▀█▀░█░█░█▀▀░█▄█░█▀▀
-- ░░█░░█▀█░█▀▀░█░█░█▀▀
-- ░░▀░░▀░▀░▀▀▀░▀░▀░▀▀▀

local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local theme = dofile(themes_path .. "default/theme.lua")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

-- ░█▀█░█▀▀░█▀▀░▀█▀░█░█░█▀▀░▀█▀░▀█▀░█▀▀░░░█▀█░▀█▀░█▀▀░█░█░▀█▀
-- ░█▀█░█▀▀░▀▀█░░█░░█▀█░█▀▀░░█░░░█░░█░░░░░█░█░░█░░█░█░█▀█░░█░
-- ░▀░▀░▀▀▀░▀▀▀░░▀░░▀░▀░▀▀▀░░▀░░▀▀▀░▀▀▀░░░▀░▀░▀▀▀░▀▀▀░▀░▀░░▀░

theme.xbackground = "#1e1e2e"
theme.xforeground = "#d9e0ee"
theme.xcolor0 = "#6e6c7e"
theme.xcolor1 = "#f28fad"
theme.xcolor2 = "#abe9b3"
theme.xcolor3 = "#fae3b0"
theme.xcolor4 = "#96cdfb"
theme.xcolor5 = "#f5c2e7"
theme.xcolor6 = "#89dceb"
theme.xcolor7 = "#d9e0ee"
theme.xcolor8 = "#988ba2"
theme.xcolor9 = "#f28fad"
theme.xcolor10 = "#abe9b3"
theme.xcolor11 = "#fae3b0"
theme.xcolor12 = "#96cdfb"
theme.xcolor13 = "#f5c2e7"
theme.xcolor14 = "#89dceb"
theme.xcolor15 = "#d9e0ee"
theme.darker_bg = "#1e1e2e"
theme.lighter_bg = "#575268"
theme.transparent = "#00000000"

-- ░█▀▀░█▀█░█▀█░▀█▀░█▀▀
-- ░█▀▀░█░█░█░█░░█░░▀▀█
-- ░▀░░░▀▀▀░▀░▀░░▀░░▀▀▀

-- Ui Fonts
theme.font_name = "Recursive Sans Casual Static "
theme.font = theme.font_name .. "Medium 10"
-- Icon Fonts
theme.icon_font = "Material Icons "

-- ░█▀▀░█▀█░█░░░█▀█░█▀▄░█▀▀
-- ░█░░░█░█░█░░░█░█░█▀▄░▀▀█
-- ░▀▀▀░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀

-- Background Colors
theme.bg_dark = theme.darker_bg
theme.bg_normal = theme.xbackground
theme.bg_focus = theme.xbackground
theme.bg_urgent = theme.xbackground
theme.bg_minimize = theme.xbackground
theme.bg_secondary = theme.darker_bg
theme.bg_accent = theme.lighter_bg

-- Foreground Colors
theme.fg_normal = theme.xforeground
theme.fg_focus = theme.accent
theme.fg_urgent = theme.xcolor1
theme.fg_minimize = theme.xcolor0

-- Accent colors
theme.accent = theme.xcolor4

-- UI events
theme.leave_event = transparent
theme.enter_event = "#ffffff" .. "10"
theme.press_event = "#ffffff" .. "15"
theme.release_event = "#ffffff" .. "10"

-- Widgets
theme.widget_bg = theme.lighter_bg

-- Titlebars
theme.titlebar_enabled = true
theme.titlebar_bg = theme.darker_bg
theme.titlebar_fg = theme.xforeground
theme.titlebar_color_unfocused = theme.xcolor8

-- Wibar
theme.wibar_bg = "#1a1b26"

-- Dashboard
theme.dashboard_bg = theme.darker_bg
theme.dashboard_box_fg = "#666C79"

-- Control center
theme.control_center_widget_radius = dpi(16)
theme.control_center_button_bg = "#ffffff" .. "10"

-- Music
theme.music_bg = theme.xbackground
theme.music_bg_accent = theme.darker_bg
theme.music_accent = theme.lighter_bg

-- ░█░█░▀█▀░░░█▀▀░█░░░█▀▀░█▄█░█▀▀░█▀█░▀█▀░█▀▀
-- ░█░█░░█░░░░█▀▀░█░░░█▀▀░█░█░█▀▀░█░█░░█░░▀▀█
-- ░▀▀▀░▀▀▀░░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░░▀░░▀▀▀

-- Wallpaper
theme.wallpaper = gfs.get_configuration_dir() .. "theme/assets/wallpaper-nixdark.png"

-- Pfp
theme.pfp = gears.surface.load_uncached(gfs.get_configuration_dir() .. "theme/assets/pfp.png")

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(dpi(30), theme.xbackground, theme.xforeground)
-- theme.awesome_icon =

-- Borders
theme.border_width = dpi(0)
theme.oof_border_width = dpi(0)
theme.border_normal = theme.darker_bg
theme.border_focus = theme.darker_bg
theme.widget_border_width = dpi(2)
theme.widget_border_color = theme.darker_bg

-- Corner Radius
theme.corner_radius = dpi(6)
theme.client_radius = theme.corner_radius
theme.dashboard_radius = theme.corner_radius
theme.widget_radius = theme.corner_radius

-- Edge snap
theme.snap_bg = theme.xcolor8
theme.snap_shape = helpers.rrect(0)

-- Playerctl
theme.playerctl_ignore = { "firefox", "qutebrowser", "chromium", "brave" }
theme.playerctl_player = { "spotify", "mpd", "%any" }
theme.playerctl_update_on_activity = true
theme.playerctl_position_update_interval = 1

-- Mainmenu
theme.menu_font = theme.font_name .. "Medium 10"
theme.menu_height = dpi(30)
theme.menu_width = dpi(150)
theme.menu_bg_normal = theme.xbackground
theme.menu_bg_focus = theme.lighter_bg
theme.menu_fg_normal = theme.xforeground
theme.menu_fg_focus = theme.accent
theme.menu_border_width = dpi(0)
theme.menu_border_color = theme.xcolor0
theme.menu_submenu = "»  "
theme.menu_submenu_icon = nil

-- Tooltip
theme.tooltip_bg = theme.darker_bg
theme.tooltip_fg = theme.xforeground
theme.tooltip_font = theme.font_name .. "Regular 10"

-- Hotkeys Pop Up
theme.hotkeys_bg = theme.xbackground
theme.hotkeys_fg = theme.xforeground
theme.hotkeys_modifiers_fg = theme.xforeground
theme.hotkeys_font = theme.font_name .. "Regular 11"
theme.hotkeys_description_font = theme.font_name .. "Regular 9"
theme.hotkeys_shape = helpers.rrect(theme.corner_radius)
theme.hotkeys_group_margin = dpi(35)

-- Tag list
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Layout List
theme.layoutlist_shape_selected = helpers.rrect(theme.corner_radius)
theme.layoutlist_bg_selected = theme.lighter_bg

-- Recolor Layout icons:
theme = theme_assets.recolor_layout(theme, theme.xforeground)

-- Gaps
theme.useless_gap = dpi(5)

-- Dock
theme.dock_bg = theme.wibar_bg
theme.dock_focused_bg = theme.lighter_bg
theme.dock_accent = theme.accent

-- Systray
theme.bg_systray = theme.wibar_bg
theme.systray_icon_spacing = dpi(16)

-- Tabs
theme.mstab_bar_height = dpi(60)
theme.mstab_bar_padding = dpi(0)
theme.mstab_border_radius = theme.corner_radius
theme.tabbar_disable = true
theme.tabbar_style = "modern"
theme.tabbar_bg_focus = theme.lighter_bg
theme.tabbar_bg_normal = theme.darker_bg
theme.tabbar_fg_focus = theme.xforeground
theme.tabbar_fg_normal = theme.xcolor0
theme.tabbar_position = "bottom"
theme.tabbar_AA_radius = 0
theme.tabbar_size = 0
theme.mstab_bar_ontop = true

-- Notifications
theme.notification_spacing = dpi(20)
theme.notification_border_radius = theme.corner_radius
theme.notification_border_width = dpi(0)

-- Notif center
theme.notif_center_radius = theme.corner_radius
theme.notif_center_box_radius = theme.notif_center_radius
theme.notif_center_notifs_bg = theme.lighter_bg
theme.notif_center_notifs_accent = theme.xcolor0

-- Swallowing
theme.dont_swallow_classname_list = {
  "firefox",
  "gimp",
  "Google-chrome",
  "Thunar",
}

-- Layout Machi
theme.machi_switcher_border_color = theme.darker_bg
theme.machi_switcher_border_opacity = 0.25
theme.machi_editor_border_color = theme.darker_bg
theme.machi_editor_border_opacity = 0.25
theme.machi_editor_active_opacity = 0.25

theme.fade_duration = 250

return theme
