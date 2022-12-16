
-- ███████╗███████╗    ██████╗ ██╗ ██████╗ 
-- ██╔════╝██╔════╝    ██╔══██╗██║██╔═══██╗
-- █████╗  █████╗█████╗██████╔╝██║██║   ██║
-- ██╔══╝  ██╔══╝╚════╝██╔══██╗██║██║   ██║
-- ███████╗██║         ██████╔╝██║╚██████╔╝
-- ╚══════╝╚═╝         ╚═════╝ ╚═╝ ╚═════╝

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi   = require("beautiful.xresources").apply_dpi

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local wallpaper_dir = "/mnt/extras/Wallpapers/"

local theme                                     = {}
-- theme.wallpaper                                 = wallpaper_dir .. "trio-dark.png"
theme.wallpaper                                 = "#00331f"

-- theme.font                                      = "Iosevka Comfy 11"
theme.font                                      = "Iosevka Nerd Font 11"
theme.taglist_font                              = theme.font

theme.notification_font                         = "Iosevka 19"
theme.notification_max_width                    = 400

theme.white                                     = "#cfdfd5"
theme.bg_dim                                    = "#222522"
theme.dark                                      = "#111111"
theme.darker                                    = "#161916"

theme.black                                     = theme.dark
theme.grey                                      = "#808f80"
theme.grey_dark                                 = "#404240"

theme.red                                       = "#ef6560"
theme.green                                     = "#3fb83f"
theme.yellow                                    = "#d4aa02"
theme.blue                                      = "#37aff6"
theme.magenta                                   = "#d38faf"
theme.cyan                                      = "#6fc5ef"
theme.red_bright                                = "#ff778f"
theme.green_bright                              = "#00c089"
theme.yellow_bright                             = "#cfc04f"
theme.blue_bright                               = "#32cfef"
theme.magenta_bright                            = "#af9fff"
theme.cyan_bright                               = "#5dc0aa"

theme.accent                                    = "#00552f"
theme.accent_bright                             = "#35f038"

theme.fg_normal                                 = theme.grey
theme.fg_focus                                  = theme.accent
theme.bg_normal                                 = theme.dark
theme.bg_focus                                  = theme.dark
theme.fg_urgent                                 = theme.red
theme.bg_urgent                                 = theme.dark
theme.border_width                              = dpi(1)
theme.border_normal                             = theme.dark
theme.border_focus                              = theme.accent_bright

theme.taglist_fg_focus                          = theme.white
theme.taglist_bg_focus                          = theme.bg_dim
theme.taglist_fg_occupied                       = theme.grey
theme.taglist_fg_empty                          = theme.grey_dark
theme.taglist_fg_urgent                         = theme.red

theme.bg_systray                                = theme.dark
theme.menu_height                               = dpi(14)
theme.menu_width                                = dpi(130)

theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = dpi(3)

theme.notification_fg                           = theme.white
theme.notification_bg                           = theme.accent
theme.notification_border_color                 = theme.accent

theme.menubar_fg_focus                          = theme.green_bright
theme.menubar_fg_normal                         = theme.white
theme.menubar_bg_normal                         = theme.dark

-- awful.util.tagnames   = { "𝟏", "𝟐", "𝟑", "𝟒", "𝟓", "𝟔"}
awful.util.tagnames   = { "1", "2", "3", "4", "5", "6", "7" }
-- awful.util.tagnames   = { "ℂ", "ℝ", "ℚ", "ℤ", "ℕ"}

local markup     = lain.util.markup
local separators = lain.util.separators

-- local clockicon = wibox.widget.imagebox(theme.widget_clock)
local clock = awful.widget.watch(
    "date +'  %d %b %a %I:%M '", 10,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, markup(theme.white, stdout)))
    end
)

-- Wifi
-- local wifi = wibox.widget { nil, neticon, net.widget, layout = wibox.layout.align.horizontal }

-- Battery
local bat = lain.widget.bat({
    settings = function()
        if bat_now.ac_status == 1 then
            bat_header = " ↑ "
            -- bat_header = " "
        else
            bat_header = " "
        end
        bat_p      = " " .. bat_now.perc
        widget:set_markup(markup.font(theme.font, markup(theme.white, bat_p .. bat_header)))
    end
})

-- ALSA volume
theme.volume = lain.widget.alsa({
    --togglechannel = "IEC958,3",
    settings = function()
        header = "  "
        vlevel  = volume_now.level

        if volume_now.status == "off" then
            vlevel = vlevel .. "M"
        else
            vlevel = vlevel .. ""
        end

        widget:set_markup(markup.font(theme.font, markup(theme.white, header .. vlevel)))
    end
})

-- Separators
local first     = wibox.widget.textbox('<span font="Iosevka Comfy 4"> </span>')

local barheight = dpi(24)
local barcolor  = theme.dark

theme.titlebar_bg = barcolor

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
    -- if type(wallpaper) == "function" then
    --     wallpaper = wallpaper(s)
    -- end
    if wallpaper:match("^#") then
       gears.wallpaper.set(wallpaper, s, true)
    else
       gears.wallpaper.maximized(wallpaper, s, true)
    end

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = barheight, bg = barcolor})

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            first,
        },
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            wibox.container.margin(theme.volume.widget, dpi(6), dpi(9)),
            wibox.container.margin(wibox.widget { bat, layout = wibox.layout.align.horizontal }, dpi(3), dpi(6)),
            clock,
	},
    }
end

return theme
