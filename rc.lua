-- {{{ Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local menubar       = require("menubar")
local freedesktop   = require("freedesktop")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility
local dpi           = require("beautiful.xresources").apply_dpi
-- }}}

globalkeys = require("myshortcuts")
awful.rules.rules = require("myrules")
-- {{{ Variable definitions

local themes = {
    "gruv",          -- 1
    "red",           -- 2
    "leaf",         -- 3
    "ocean",         -- 4
    "pink",          -- 5
    "square",        -- 6
    "one-dark",      -- 7
    "warm",          -- 8
    "pastel",        -- 9
    "two-dark",      -- 10
}

local chosen_theme = themes[9]
local modkey       = "Mod4"
local altkey       = "Mod1"
local vi_focus     = false -- vi-like client focus - https://github.com/lcpz/awesome-copycats/issues/275
local cycle_prev   = true -- cycle trough all previous client or just the first -- https://github.com/lcpz/awesome-copycats/issues/274
local editor       = os.getenv("EDITOR") or "kak"
local gui_editor   = os.getenv("GUI_EDITOR") or "mousepad"
local browser      = os.getenv("BROWSER") or "brave"

awful.util.terminal = terminal
-- awful.util.tagnames = { "1", "2", "3", "4", "5" }
awful.layout.layouts = {
     -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
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

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
-- }}}

-- This is used later as the default terminal and editor to run.
browser = "exo-open --launch WebBrowser" or "brave"
filemanager = "nemo"
gui_editor = "mousepad"
terminal = "alacritty"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.

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

-- local myawesomemenu = {
--     { "hotkeys", function() return false, hotkeys_popup.show_help end },
--     { "manual", terminal .. " -e man awesome" },
--     { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
--     { "restart", awesome.restart },
--     { "quit", function() awesome.quit() end }
-- }
-- awful.util.mymainmenu = freedesktop.menu.build({
--     icon_size = beautiful.menu_height or dpi(16),
--     before = {
--         { "Awesome", myawesomemenu, beautiful.awesome_icon },
--         -- other triads can be put here
--     },
--     after = {
--         { "Open terminal", terminal },
--         -- other triads can be put here
--     }
-- })

-- myexitmenu = {
--     { "log out", function() awesome.quit() end, menubar.utils.lookup_icon("system-log-out") },
--     { "suspend", "systemctl suspend", menubar.utils.lookup_icon("system-suspend") },
--     { "hibernate", "systemctl hibernate", menubar.utils.lookup_icon("system-suspend-hibernate") },
--     { "reboot", "systemctl reboot", menubar.utils.lookup_icon("system-reboot") },
--     { "shutdown", "poweroff", menubar.utils.lookup_icon("system-shutdown") }
-- }

-- mymainmenu = freedesktop.menu.build({
--     icon_size = 32,
--     before = {
--         { "Terminal", terminal, menubar.utils.lookup_icon("utilities-terminal") },
--         { "Browser", browser, menubar.utils.lookup_icon("internet-web-browser") },
--         { "Files", filemanager, menubar.utils.lookup_icon("system-file-manager") },
--         -- other triads can be put here
--     },
--     after = {
--         { "Awesome", myawesomemenu, "/usr/share/awesome/icons/awesome32.png" },
--         { "Exit", myexitmenu, menubar.utils.lookup_icon("system-shutdown") },
--         -- other triads can be put here
--     }
-- })
-- -- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
--                                      -- menu = mymainmenu })
-- -- Menubar configuration
-- menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- -- }}}
-- -- mykeyboardlayout = awful.widget.keyboardlayout()

darkblue    = beautiful.bg_focus
blue        = "#9EBABA"
red         = "#EB8F8F"

awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Signals


-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
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

end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Disable borders on lone windows
-- Handle border sizes of clients.
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
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
end)
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

awful.spawn("/home/krishna/.config/awesome/autorun.sh")
--local useless_gap = tag.getgap(tag.selected(screen), #client.tiled(s))
