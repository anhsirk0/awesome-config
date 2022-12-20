local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.font                                      = "Iosevka Comfy 9"
theme.taglist_font                              = "Iosevka Comfy 9"
theme.orange                                    = "#efff73"
theme.pink                                      = "#FA1950"
theme.blue                                      = "#a3f7ff"
theme.red                                       = "#ffe585"
theme.accent                                    = "#2dfea2"
theme.white                                     = "#ffffff"
-- theme.white                                     = colors.white
theme.indigo                                    = "#9fa8da"
theme.green                                     = "#64de83"
theme.light_green                               = "#69f0ae"
theme.teal                                      = "#1de9b6"
theme.purple                                    = "#ea80fc"
theme.amber                                     = "#ffecb3"
theme.dark                                      = "#272727"
theme.transparent                               = "#E6000000"

theme.fg_normal                                 = "#D7D7D7"
theme.fg_focus                                  = theme.accent
theme.bg_normal                                 = theme.dark
theme.bg_focus                                  = theme.dark
theme.fg_urgent                                 = "#CC9393"
theme.bg_urgent                                 = "#2A1F1E"
theme.border_width                              = dpi(1)
theme.border_normal                             = theme.dark
theme.border_focus                              = theme.orange

theme.taglist_fg_focus                          = theme.dark
theme.taglist_bg_focus                          = theme.amber

theme.taglist_fg_occupied                       = theme.dark
theme.taglist_bg_occupied                       = theme.light_green

theme.taglist_fg_empty                          = theme.dark
theme.taglist_bg_empty                          = theme.indigo

theme.taglist_fg_urgent                         = theme.pink

theme.tasklist_fg_focus                         = "#F6784F"
theme.tasklist_bg_focus                         = "#060606"
theme.bg_systray                                = theme.light_green
theme.menu_height                               = dpi(14)
theme.menu_width                                = dpi(130)
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = dpi(3)

-- awful.util.tagnames   = { "𝟏", "𝟐", "𝟑", "𝟒", "𝟓", "𝟔"}
awful.util.tagnames   = { " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 "}
-- awful.util.tagnames   = { "a", "w", "e", "s", "o", "m", "e"}
-- awful.util.tagnames   = { "A", "W", "E", "S", "O", "M", "E"}

local markup     = lain.util.markup
local separators = lain.util.separators
local gray       = "#9E9C9A"
local arrow = separators.arrow_left

-- Textclock
local mytextclock = wibox.widget.textclock(" %I:%M ")
mytextclock.font = theme.font

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { mytextclock },
    notification_preset = {
        font = theme.font,
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

-- local clockicon = wibox.widget.imagebox(theme.widget_clock)
local clock = awful.widget.watch(
    "date +' %d %b %a %I:%M '", 10,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, markup(theme.dark, stdout)))
    end
)


-- Battery
local bat = lain.widget.bat({
    settings = function()
        bat_header = ""
        -- bat_header = ""
        bat_p      = " " .. bat_now.perc
        widget:set_markup(markup.font(theme.font, markup(theme.dark, bat_header .. bat_p)))
    end
})

-- ALSA volume
theme.volume = lain.widget.alsa({
    --togglechannel = "IEC958,3",
--    bg = theme.red
    settings = function()
        header = "  "
        vlevel  = volume_now.level

        if volume_now.status == "off" then
            vlevel = vlevel .. "M "
        else
            vlevel = vlevel .. " "
        end

        widget:set_markup(markup.font(theme.font, markup(theme.dark, header .. vlevel)))
    end
})

-- Separators
local first     = wibox.widget.textbox('<span font="Terminus 4"> </span>')
local empty     = wibox.container.background(wibox.container.margin(wibox.widget { first, layout = wibox.layout.align.horizontal }, dpi(3), dpi(3)), theme.bg_systray)
local barheight = dpi(18)

local barcolor  = gears.color({
    type  = "linear",
    from  = { barheight, 0 },
    to    = { barheight, barheight },
    stops = { {0, theme.dark }, {1, theme.dark}, {1, "#1A1A1A"} }
})

theme.titlebar_bg = barcolor

theme.titlebar_bg_focus = gears.color({
    type  = "linear",
    from  = { barheight, 0 },
    to    = { barheight, barheight },
    stops = { {0, theme.bg_normal}, {0.5, theme.border_normal}, {1, "#492417"} }
})

local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)


    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = dpi(18), bg = barcolor })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            first,
            s.mypromptbox,
        },
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            empty,
            -- net,
            -- mytextwidget,
            -- first,
            wibox.container.background(wibox.container.margin(theme.volume.widget, dpi(4), dpi(8)), theme.orange),
            -- theme.volume.widget,
            -- first,
            wibox.container.background(wibox.container.margin(wibox.widget { bat.widget, layout = wibox.layout.align.horizontal }, dpi(3), dpi(3)), theme.blue),
            -- bat_icon,
            -- bat,
            wibox.container.background(wibox.container.margin(wibox.widget { clock, layout = wibox.layout.align.horizontal }, dpi(3), dpi(3)), theme.amber),
            -- first,
            -- clock,
            -- wibox.container.background(wibox.container.margin(clock, dpi(4), dpi(8)), theme.green),
            -- mytextclock,
        },
    }
end

return theme
