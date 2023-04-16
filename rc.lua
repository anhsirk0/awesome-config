-- {{{ Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag

local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local lain      = require("lain")
local dpi       = require("beautiful.xresources").apply_dpi
                  require("awful.autofocus")
-- }}}

globalkeys = require("keys.keys")

awful.util.terminal = terminal
awful.layout.layouts = {
   -- awful.layout.suit.floating,
   -- awful.layout.suit.spiral.dwindle,
   awful.layout.suit.tile,
   awful.layout.suit.tile.bottom,
   -- awful.layout.suit.tile.left,
   -- awful.layout.suit.spiral,
   -- awful.layout.suit.tile.top,
   -- awful.layout.suit.fair,
   --awful.layout.suit.fair.horizontal,
   --awful.layout.suit.max,
   --awful.layout.suit.max.fullscreen,
   --awful.layout.suit.magnifier,
   --awful.layout.suit.corner.nw,
   --awful.layout.suit.corner.ne,
   --awful.layout.suit.corner.sw,
   --awful.layout.suit.corner.se,
   -- lain.layout.cascade,
   -- lain.layout.cascade.tile,
   -- lain.layout.centerwork,
   -- lain.layout.centerwork.horizontal,
   --lain.layout.termfair,
   --lain.layout.termfair.center,
}

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = dpi(2)
lain.layout.cascade.tile.offset_y      = dpi(32)
lain.layout.cascade.tile.extra_padding = dpi(5)
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

-- for new themes
beautiful.init(string.format("%s/.config/awesome/theme.lua", os.getenv("HOME")))

-- -- Use this for old-themes
-- local chosen_theme = "operandi"
-- beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
-- }}}

-- {{{ Set Rules
awful.rules.rules = require("rules.rules")
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
   local instance = nil
   return function ()
      if instance and instance.wibox.visible then
         instance:hide()
         instance = nil
      else
         instance = awful.menu.clients({ theme = { width = 250 } })
      end
   end
end
-- }}}

awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal(
   "manage",
   function (c)
      -- Set the windows at the slave,
      -- i.e. put it at the end of others instead of setting it master.
      -- if not awesome.startup then awful.client.setslave(c) end

      if awesome.startup and
         not c.size_hints.user_position
         and not c.size_hints.program_position then
         -- Prevent clients from being unreachable after screen count changes.
         awful.placement.no_offscreen(c)
      end
   end
)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal(
   "request::titlebars",
   function(c)
      -- buttons for the titlebar
      local buttons = gears.table.join(
         awful.button({ }, 1, function()
               client.focus = c
               c:raise()
               awful.mouse.client.move(c)
         end),
         awful.button({ }, 3, function()
               client.focus = c
               c:raise()
               awful.mouse.client.resize(c)
         end)
      )
      end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
   "mouse::enter",
   function(c)
      if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
         and awful.client.focus.filter(c) then
         client.focus = c
      end
   end
)

-- local function manage_rounded_corner(c)
--    local t = awful.screen.focused().selected_tag
--    if #t:clients() == 1 then
--       rounded_corner = 0
--    else
--       rounded_corner = beautiful.rounded_corner
--    end
--    c.shape = function(cr, w, h)
--       gears.shape.rounded_rect(cr, w, h, rounded_corner)
--    end
-- end

-- client.connect_signal(
--    "manage",
--    manage_rounded_corner
-- )

-- client.connect_signal(
--    "unmanage",
--    manage_rounded_corner
-- )

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Disable borders on lone windows
-- Handle border sizes of clients.
for s = 1, screen.count() do
   screen[s]:connect_signal(
      "arrange",
      function ()
         local clients = awful.client.visible(s)
         local layout = awful.layout.getname(awful.layout.get(s))

         for _, c in pairs(clients) do
            -- No borders with only one humanly visible client
            if c.maximized then
               -- NOTE: also handled in focus, but that does not cover maximizing from a
               -- tiled state (when the client had focus).
               c.border_width = 0
            elseif c.floating or layout == "floating" then
               c.border_width = beautiful.border_width
            elseif layout == "max" or layout == "fullscreen" then
               c.border_width = 0
            else

               local tiled = awful.client.tiled(c.screen)
               if #tiled == 1 then
                  tiled[1].border_width = 0
                  -- if layout ~= "max" and layout ~= "fullscreen" then
                  -- XXX: SLOW!
                  -- awful.client.moveresize(0, 0, 2, 0, tiled[1])
                  -- end
               else
                  c.border_width = beautiful.border_width
               end
            end
         end
      end
   )
end

beautiful.gap_single_client = false
-- }}}

--client.connect_signal("property::floating", function (c)
--    if c.floating then
--        awful.titlebar.show(c)
--    else
--        awful.titlebar.hide(c)
--    end
--end)

awful.spawn(os.getenv("HOME") .. "/.config/awesome/scripts/autorun.sh")

