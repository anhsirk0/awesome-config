--[[

     Awesome WM configuration template
     github.com/lcpz

--]]

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
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility
local dpi           = require("beautiful.xresources").apply_dpi
-- }}}

-- {{{ Variable definitions

local themes = {
    "blackburn",       -- 1
    "red",         -- 2
    "green",         -- 3
    "holo",            -- 4
    "multicolor",      -- 5
    "powerarrow",      -- 6
    "powerarrow-dark", -- 7
    "rainbow",         -- 8
    "steamburn",       -- 9
    "vertex",          -- 10
    "pink",          -- 11
    "square",          -- 12
    "gruv",          -- 13
}

local chosen_theme = themes[12]
local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "alacritty"
local vi_focus     = false -- vi-like client focus - https://github.com/lcpz/awesome-copycats/issues/275
local cycle_prev   = true -- cycle trough all previous client or just the first -- https://github.com/lcpz/awesome-copycats/issues/274
local editor       = os.getenv("EDITOR") or "micro"
local gui_editor   = os.getenv("GUI_EDITOR") or "mousepad"
local browser      = os.getenv("BROWSER") or "brave"

awful.util.terminal = terminal
-- awful.util.tagnames = { "1", "2", "3", "4", "5" }
awful.layout.layouts = {
     -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
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

local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end }
}
awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or dpi(16),
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
})

myexitmenu = {
    { "log out", function() awesome.quit() end, menubar.utils.lookup_icon("system-log-out") },
    { "suspend", "systemctl suspend", menubar.utils.lookup_icon("system-suspend") },
    { "hibernate", "systemctl hibernate", menubar.utils.lookup_icon("system-suspend-hibernate") },
    { "reboot", "systemctl reboot", menubar.utils.lookup_icon("system-reboot") },
    { "shutdown", "poweroff", menubar.utils.lookup_icon("system-shutdown") }
}

mymainmenu = freedesktop.menu.build({
    icon_size = 32,
    before = {
        { "Terminal", terminal, menubar.utils.lookup_icon("utilities-terminal") },
        { "Browser", browser, menubar.utils.lookup_icon("internet-web-browser") },
        { "Files", filemanager, menubar.utils.lookup_icon("system-file-manager") },
        -- other triads can be put here
    },
    after = {
        { "Awesome", myawesomemenu, "/usr/share/awesome/icons/awesome32.png" },
        { "Exit", myexitmenu, menubar.utils.lookup_icon("system-shutdown") },
        -- other triads can be put here
    }
})
-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     -- menu = mymainmenu })
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}
-- mykeyboardlayout = awful.widget.keyboardlayout()

darkblue    = beautiful.bg_focus
blue        = "#9EBABA"
red         = "#EB8F8F"

awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

-- {{{ Key bindings
globalkeys = gears.table.join(
    -- awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
    --           {description="show help", group="awesome"}),

    awful.key({ modkey,           }, "Left",
    	function()
    	   awful.client.focus.byidx( 1)
    	end,
        {description = "view previous", group = "client"}),

    awful.key({ modkey,           }, "Right",
    	function()
    	   awful.client.focus.byidx(-1)
    	end,
        {description = "view previous", group = "client"}),

    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () awful.spawn("rofi -show window -theme /home/krishna/.config/rofi/launchers/text/style_1")  end,
              {description = "show all windows from all workspaces", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    -- my edits
    awful.key({ modkey, "Shift"   }, "Left", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Right", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey,           }, "z", awful.tag.viewprev,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.03)                 end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.03)                 end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true)        end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true)        end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)           end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)           end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey     }, "b", function () awful.spawn(browser)          end,
              {description = "launch Browser", group = "launcher"}),
    awful.key({ modkey, "Shift"    }, "b", function () awful.spawn("brave --incognito")          end,
              {description = "launch Browser", group = "launcher"}),
    awful.key({ modkey,           }, "e", function () awful.spawn('nemo')            end,
              {description = "launch filemanager", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                       end,
              {description = "select previous", group = "layout"}),


-- my_shortcuts {{
    awful.key({ modkey,           }, "q", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
              
    awful.key({ modkey, "Mod1"    }, "Up",     function () awful.client.incwfact( 0.05)    end,
              {description = "increase client size vertically", group = "client"}),
    
    awful.key({ modkey, "Mod1"    }, "Down",     function () awful.client.incwfact(-0.05)    end,
              {description = "decrease client size vertically", group = "client"}),
              
    awful.key({ modkey, "Mod1"    }, "Right",     function () awful.tag.incmwfact( 0.05)    end,
              {description = "increase master width factor", group = "layout"}),
              
    awful.key({ modkey, "Mod1"    }, "Left",     function () awful.tag.incmwfact(-0.05)    end,
              {description = "decrease master width factor", group = "layout"}),
    
    awful.key({ modkey,           }, "i", function () awful.spawn("xdman")            end,
              {description = "launch xdm", group = "launcher"}),

    awful.key({ modkey,           }, "x", function () awful.spawn("lollypop -t")            end,
              {description = "toggle play / launch lollypop", group = "lollypop"}),

    awful.key({ modkey,           }, ".", function () awful.spawn("lollypop -n")            end,
              {description = "play next", group = "lollypop"}),

    awful.key({ modkey,           }, ",", function () awful.spawn("lollypop -p")            end,
              {description = "play previous", group = "lollypop"}),

    awful.key({ modkey,     }, "d", function () awful.spawn("/home/krishna/.config/rofi/launchers/text/launcher.sh") end,
              {description = "launch rofi", group = "launcher"}),
              
    awful.key({ modkey,    }, "s", function () awful.spawn("/home/krishna/.config/rofi/lollypop/text/launcher.sh") end,
              {description = "search and add a song to playlist ", group = "lollypop"}),
              
    awful.key({ modkey,    }, "o", function () awful.spawn("/home/krishna/.config/rofi/command/text/launcher.sh") end,
              {description = "Run common commands", group = "launcher"}),
              
    awful.key({ modkey,    }, "a", function () awful.spawn("/home/krishna/.config/rofi/helper/text/light_launcher.sh") end,
             {description = "Control brightness", group = "launcher"}),
              
    awful.key({ modkey,   }, "v", function () awful.spawn("/home/krishna/.config/rofi/helper/text/sound_launcher.sh") end,
             {description = "Control volume", group = "launcher"}),
              
    awful.key({ modkey, altkey  }, "b", function () awful.spawn("/home/krishna/.config/rofi/brave/text/launcher.sh") end,
             {description = "Brave menu ", group = "launcher"}),

    awful.key({ modkey, altkey }, "l",     function () awful.tag.incmwfact( 0.01)                 end,
              {description = "increase master width factor 1", group = "layout"}),
    awful.key({ modkey, altkey }, "h",     function () awful.tag.incmwfact(-0.01)                 end,
              {description = "decrease master width factor 1", group = "layout"}),

    awful.key({                   }, "Print", function () awful.spawn("/home/krishna/.scripts/full_screenshot")   end,
              {description = "capture a screenshot", group = "screenshot"}),
    awful.key({"Control"          }, "Print", function () awful.spawn("/home/krishna/.scripts/window_screenshot")   end,
              {description = "capture a screenshot of active window", group = "screenshot"}),
    awful.key({"Shift"            }, "Print", function () awful.spawn("/home/krishna/.scripts/area_screenshot")   end,
              {description = "capture a screenshot of selection", group = "screenshot"}),
-- my_shortcuts ends }}

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "ö",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) awful.spawn("xkill")                         end,
              {description = "xkill", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    -- awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
    --           {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),

    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.

local np_map = { 87, 88, 89, 83, 84, 85, 79, 80, 81 }
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. np_map[i],
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. np_map[i],
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. np_map[i],
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. np_map[i],
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"}),


-- This should map on the top row of your keyboard, usually 1 to 9.
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise()
                 mymainmenu:hide() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ altkey }, 1, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false, -- Remove gaps between terminals
                     screen = awful.screen.preferred,
                     callback = awful.client.setslave,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" } },
      properties = { titlebars_enabled = true }
    },
	
    -- Set Lollypop to always map on the tag named "3" on screen 1.
    { rule = { class = "Lollypop" },
    properties = { screen = 1, tag = "3" } ,
    callback = function ()
                 local screen = awful.screen.focused()
                 local tag = screen.tags[3]
                 if tag then
                    tag:view_only()
                 end
           end
    },

    -- fix brave apps (lichess , whatsapp) floating mode
    -- lichess
    { rule = { instance = "crx_pdihgkikjgccndbckbcgjmcnpkockcjg" },
    properties = { floating = false } ,
    callback = function ()
    			awful.tag.incmwfact( 0.10)
   			end
	},

	-- whatsapp
    { rule = { instance = "crx_hnpfjngllnobngcgfapefoaidbinmjnm" },
    properties = { floating = false } },
    
}
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

    -- awful.titlebar(c) : setup {
        -- { -- Left
            -- awful.titlebar.widget.iconwidget(c),
            -- buttons = buttons,
            -- layout  = wibox.layout.fixed.horizontal
        -- },
        -- { -- Middle
            -- { -- Title
                -- align  = "center",
                -- widget = awful.titlebar.widget.titlewidget(c)
            -- },
            -- buttons = buttons,
            -- layout  = wibox.layout.flex.horizontal
        -- },
        -- { -- Right
            -- awful.titlebar.widget.floatingbutton (c),
            -- awful.titlebar.widget.stickybutton   (c),
           -- -- awful.titlebar.widget.ontopbutton    (c),
            -- awful.titlebar.widget.maximizedbutton(c),
            -- awful.titlebar.widget.closebutton    (c),
            -- layout = wibox.layout.fixed.horizontal()
        -- },
        -- layout = wibox.layout.align.horizontal
    -- }
        -- Hide the menubar if we are not floating
   -- local l = awful.layout.get(c.screen)
   -- if not (l.name == "floating" or c.floating) then
   --     awful.titlebar.hide(c)
   -- end
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

-- awful.spawn.with_shell("/usr/lib/xfce4/notifyd/xfce4-notifyd")
awful.spawn("/home/krishna/.config/awesome/autorun.sh")
--local useless_gap = tag.getgap(tag.selected(screen), #client.tiled(s))
