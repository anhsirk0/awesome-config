local bling = require("bling")
local gears = require("gears")
local awful = require("awful")
local dpi = require("beautiful.xresources").apply_dpi
local bar = require("bar")
local naughty = require("naughty")

-- For changing themes
local chosen_theme = "vivendi"
local colors = require("themes." .. chosen_theme .. ".colors")

local theme = colors
theme.font = "Aporetic Serif Mono 11"
-- theme.font                      = "Fantasque Sans Mono 11"
-- theme.font                      = "Iosevka Comfy 10"
-- theme.font                      = "iA Writer Mono S 10"
theme.taglist_font = theme.font
-- theme.taglist_font              = "awesomewm-font 13"

theme.notification_font = "Aporetic Serif 20"
theme.notification_max_width = 400

theme.fg_normal = theme.fg_main
theme.fg_focus = theme.fb_main
theme.bg_normal = theme.bg_main
theme.bg_focus = theme.bg_main
theme.fg_urgent = theme.red
theme.bg_urgent = theme.black
theme.border_normal = theme.bg_main
-- theme.border_normal             = "#000000FF"
theme.border_focus = theme.bg_accent_alt

theme.taglist_fg_focus = theme.fg_accent_alt
theme.taglist_bg_focus = theme.bg_accent_alt
theme.taglist_fg_occupied = theme.fg_main
-- theme.taglist_bg_occupied       = theme.bg_inactive
theme.taglist_fg_empty = theme.fg_dim
theme.taglist_fg_urgent = theme.fg_main
theme.taglist_bg_urgent = theme.red

theme.barcolor = theme.bg_main
theme.bg_systray = theme.bg_main
theme.border_width = dpi(2)
theme.useless_gap = dpi(4)
-- theme.useless_gap               = dpi(0)

theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = true

theme.notification_fg = theme.fg_accent_alt
theme.notification_bg = theme.bg_accent_alt
theme.notification_border_color = theme.bg_accent_alt

naughty.config.defaults.margin = dpi(12)

theme.menubar_fg_focus = theme.fg_accent_alt
theme.menubar_bg_focus = theme.bg_accent_alt
theme.menubar_fg_normal = theme.fg_dim
theme.menubar_bg_normal = theme.bg_main
theme.menubar_border_color = theme.bg_main
theme.menubar_border_width = dpi(4)

-- Rounded corners
-- theme.rounded_corner            = 16
-- theme.notification_shape        = function (cr, w, h)
--    gears.shape.rounded_rect(cr, w, h, theme.rounded_corner)
-- end

-- awful.util.tagnames             = { "𝟏", "𝟐", "𝟑", "𝟒", "𝟓", "𝟔", "𝟕" }
awful.util.tagnames = { "1", "2", "3", "4", "5", "6", "7" }
-- awful.util.tagnames             = { "A", "W", "E", "S", "O", "M", "E" }

function theme.at_screen_connect(s)
	if theme.wallpaper:match("^#") then
		-- local symbol = "♥"
		-- local symbol = "✿"
		local symbol = "⚝"
		bling.module.tiled_wallpaper(symbol, s, {
			fg = theme.bg_accent_alt, -- define the foreground color
			bg = theme.wallpaper, -- define the background color
			offset_y = 10, -- set a y offset
			offset_x = 10, -- set a x offset
			font = "Noto Sans Symbols", -- set the font (without the size)
			-- font = "DejaVu Sans",  -- set the font (without the size)
			font_size = 30, -- set the font size
			padding = 140, -- set padding (default is 100)
			zickzack = true, -- rectangular pattern or criss cross
		})

	-- gears.wallpaper.set(theme.wallpaper, s, true)
	else
		gears.wallpaper.maximized(theme.wallpaper, s, true)
	end

	-- Tags
	awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

	bar(s, theme)
end

return theme
