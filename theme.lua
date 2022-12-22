-- Entry point for themes

local gears         = require("gears")
local awful         = require("awful")
local dpi           = require("beautiful.xresources").apply_dpi
local bar           = require("bar.bar")

-- For changing themes
local chosen_theme = "ef-autumn"
local colors        = require("themes." .. chosen_theme .. ".colors")

local theme                                     = colors
theme.font                                      = "Iosevka Nerd Font 11"
theme.taglist_font                              = theme.font

theme.notification_font                         = "Iosevka 19"
theme.notification_max_width                    = 400

-- theme.fg_normal                                 = theme.fg_dim
-- theme.fg_focus                                  = theme.fb_main
-- theme.bg_normal                                 = theme.black
-- theme.bg_focus                                  = theme.black
-- theme.fg_urgent                                 = theme.red
-- theme.bg_urgent                                 = theme.black
theme.border_normal                             = theme.bg_main
theme.border_focus                              = theme.bg_accent_alt

theme.taglist_fg_focus                          = theme.fg_main
theme.taglist_bg_focus                          = theme.bg_active
theme.taglist_fg_occupied                       = theme.fg_dim
theme.taglist_fg_empty                          = theme.bg_active
theme.taglist_fg_urgent                         = theme.red

theme.bg_systray                                = theme.bg_main
theme.border_width                              = dpi(1)
theme.menu_height                               = dpi(14)
theme.menu_width                                = dpi(130)
theme.useless_gap                               = dpi(3)

theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true

theme.notification_fg                           = theme.fg_accent
theme.notification_bg                           = theme.bg_accent
theme.notification_border_color                 = theme.bg_accent

theme.menubar_fg_focus                          = theme.fg_alt
theme.menubar_fg_normal                         = theme.fg_main
theme.menubar_bg_normal                         = theme.bg_main

theme.barcolor = theme.bg_main
awful.util.tagnames   = { "1", "2", "3", "4", "5", "6", "7" }

function theme.at_screen_connect(s)

   if theme.wallpaper:match("^#") then
      gears.wallpaper.set(theme.wallpaper, s, true)
   else
      gears.wallpaper.maximized(theme.wallpaper, s, true)
   end

   -- Tags
   awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

   bar(s, theme)
end

return theme
