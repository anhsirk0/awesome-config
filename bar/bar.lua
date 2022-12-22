local gears  = require("gears")
local lain   = require("lain")
local awful  = require("awful")
local wibox  = require("wibox")
local dpi    = require("beautiful.xresources").apply_dpi
local markup = lain.util.markup

local bar = function(s, theme)
   local barheight = dpi(24)
   local separator = wibox.container.margin(
      wibox.widget.textbox(" "), dpi(3), dpi(3)
   )
   local clock = awful.widget.watch(
      "date +'  %d %b %a %I:%M '", 10,
      function(widget, stdout)
         widget:set_markup(markup.font(theme.font, markup(theme.white, stdout)))
      end
   )

   local battery = lain.widget.bat({
         settings = function()
            if bat_now.ac_status == 1 then
               bat_header = " ↑ "
               -- bat_header = " "
            else
               bat_header = ""
            end
            bat_p = " " .. bat_now.perc
            widget:set_markup(
               markup.font(theme.font, markup(theme.white, bat_p .. bat_header))
            )
         end
   })

   local volume = lain.widget.alsa({
         settings = function()
            header = "  "
            vlevel = volume_now.level

            if volume_now.status == "off" then
               vlevel = vlevel .. "M"
            else
               vlevel = vlevel .. ""
            end

            widget:set_markup(
               markup.font(theme.font, markup(theme.white, header .. vlevel))
            )
         end
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

   local mytaglist = awful.widget.taglist(
      s, awful.widget.taglist.filter.all, taglist_buttons
   )

   -- Create the wibox
   -- Name is later used to toggle the bar visiblity
   s.mywibar = awful.wibar({
         position = "bottom", screen = s, height = barheight, bg = theme.barcolor
   })

   -- Add widgets to the wibox
   s.mywibar:setup {
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
         layout = wibox.layout.fixed.horizontal,
         mytaglist,
      },
      nil,
      { -- Right widgets
         layout = wibox.layout.fixed.horizontal,
         wibox.widget.systray(),
         volume,
         separator,
         battery,
         separator,
         clock,
      },
   }
end

return bar
