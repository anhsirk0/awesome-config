local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi
local markup = lain.util.markup

local bar = function(s, theme)
	local barheight = dpi(26)
	local separator = wibox.container.margin(
		wibox.widget({
			markup = "|",
			align = "center",
			valign = "center",
			opacity = 0.3,
			widget = wibox.widget.textbox,
		}),
		dpi(6),
		dpi(6)
	)

	local clock = wibox.widget.textclock("%d %b %a, %I:%M ")

	local battery = lain.widget.bat({
		settings = function()
			if bat_now.ac_status == 1 then
				bat_header = " ↑ "
			else
				bat_header = ""
			end
			-- bat_p = " " .. bat_now.perc
			bat_p = "B " .. bat_now.perc
			widget:set_markup(markup.font(theme.font, markup(theme.fg_main, bat_p .. bat_header)))
		end,
	})

	local volume = lain.widget.alsa({
		settings = function()
			-- header = "   "
			header = "V "
			color = theme.fg_main
			vlevel = volume_now.level

			if tonumber(vlevel) >= 115 then
				color = theme.red
				header = "VOLUME IS TOO FUCKING HIGH: V "
			end

			if volume_now.status == "off" then
				vlevel = vlevel .. "M"
			else
				vlevel = vlevel .. ""
			end

			widget:set_markup(markup.font(theme.font, markup(color, header .. vlevel)))
		end,
	})

	local lollypop = awful.widget.watch(
		"/home/krishna/.config/myshell/scripts/get-lollypop-title",
		1,
		function(widget, stdout)
			local font_color = theme.fg_main
			widget:set_markup(markup.font(theme.font, markup(font_color, awful.util.escape(stdout))))
		end
	)
	lollypop:buttons(gears.table.join(
		lollypop:buttons(),
		awful.button({}, 1, nil, function()
			awful.spawn("lollypop -t")
		end)
	))

	-- local xdm = awful.widget.watch("/home/krishna/.config/myshell/scripts/get-xdm-count", 1, function(widget, stdout)
	-- 	local font_color = theme.fg_main
	-- 	local downloads = awful.util.escape(stdout)
	-- 	local info = string.len(downloads) > 0 and " X " .. downloads or ""
	-- 	widget:set_markup(markup.font(theme.font, markup(font_color, info)))
	-- end)
	-- xdm:buttons(gears.table.join(
	-- 	xdm:buttons(),
	-- 	awful.button({}, 1, nil, function()
	-- 		awful.spawn("/mnt/projects/suckless/dmenu/scripts/xdm.pl")
	-- 	end)
	-- ))

	local taglist_buttons = gears.table.join(
		awful.button({}, 1, function(t)
			t:view_only()
		end),
		awful.button({ modkey }, 1, function(t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end),
		awful.button({}, 3, awful.tag.viewtoggle),
		awful.button({ modkey }, 3, function(t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end),
		awful.button({}, 4, function(t)
			awful.tag.viewnext(t.screen)
		end),
		awful.button({}, 5, function(t)
			awful.tag.viewprev(t.screen)
		end)
	)

	local mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

	-- Create the wibox
	-- Name is later used to toggle the bar visiblity
	s.mywibar = awful.wibar({
		position = "bottom",
		screen = s,
		height = barheight,
		bg = theme.barcolor,
	})

	-- Add widgets to the wibox
	s.mywibar:setup({
		layout = wibox.layout.align.horizontal,
		expand = "none",
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			mytaglist,
		},
		clock,
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			wibox.widget.systray(),
			-- xdm,
			separator,
			volume,
			separator,
			battery,
			separator,
			lollypop,
		},
	})
end

return bar
