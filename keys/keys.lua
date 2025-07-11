-- My shortcuts for awesomewm
local gears   = require("gears")
local awful   = require("awful")
local naughty = require("naughty")

local menubar = require("menubar")
local spawn   = awful.spawn

local hotkeys_popup   = require("awful.hotkeys_popup")
local modkey             = "Mod4"

-- swap alt and ctrl (for Emacs reasons)
local altkey          = "Control"
local ctrlkey         = "Mod1"

local home            = os.getenv("HOME")
local terminal        = "st"
-- local terminal        = "wezterm"
local file_manager    = "nemo"
-- local color_picker    = "gpick"

local browser         = "waterfox"
local private_browser = browser .. " --private-window"
-- local browser         = "brave-browser"
-- local private_browser = browser .. " --incognito"

-- local dmenu_dir        = home .. "/.config/dmenu/"
local dmenu_dir        = "/mnt/projects/suckless/dmenu/scripts/"
local rofi_dir        = home .. "/.config/rofi/"
local scripts_dir     = home .. "/.config/myshell/scripts/"
-- local lockscreen      = "betterlockscreen -l"

local get_brightness = "xbacklight -get"
local volume         = scripts_dir .. "/volume" -- codeberg.org/anhsirk0/volume

menubar.show_categories = false

local function keychord(chords)
    local g = awful.keygrabber {
        stop_key = "Escape",
        keypressed_callback = function(self, _, key)
            if chords[key] then
                chords[key]()
            end
            self:stop()
        end,
    }
    return function() g:start() end
end

function spawn_and_notify(command, message, message_cmd)
   spawn(command)
   if not message_cmd then
      naughty.notify { text = message }
      do return end
   end

   -- `volume -get` is slightly faster than `volume -set`
   os.execute("sleep 0.1")
   spawn.easy_async(
      message_cmd,
      function(stdout, stderr, reason, exit_code)
         naughty.destroy_all_notifications()
         naughty.notify {
            text = message .. string.gsub(stdout, "\n", "")
         }
      end
   )
end

-- {{{ Key bindings
local globalkeys = gears.table.join(
   awful.key({ modkey, "Shift" }, "/", hotkeys_popup.show_help,
               {description="show help", group="awesome"}),

   awful.key({}, "F12", nil,
      function () my_dropdown:toggle() end),

   awful.key({ modkey, }, "Left",
      function() awful.client.focus.bydirection("left") end,
      {description = "view previous", group = "client"}),

   awful.key({ modkey, }, "Right",
      function() awful.client.focus.bydirection("right") end,
      {description = "view previous", group = "client"}),

   awful.key({ modkey, }, "Up",
      function() awful.client.focus.bydirection("up") end,
      {description = "view previous", group = "client"}),

   awful.key({ modkey, }, "Down",
      function() awful.client.focus.bydirection("down") end,
      {description = "view previous", group = "client"}),

   -- awful.key({ modkey, }, "Escape", awful.tag.history.restore,
   -- {description = "go back", group = "tag"}),

   awful.key({ modkey, }, "j",
      function () awful.client.focus.byidx( 1) end,
      {description = "focus next by index", group = "client"}
   ),

   awful.key({ modkey, }, "k",
      function () awful.client.focus.byidx(-1) end,
      {description = "focus previous by index", group = "client"}
   ),

   awful.key({ modkey, }, "w",
      function () spawn(dmenu_dir .. "windows.pl") end,
      {description = "show all windows (all workspaces)", group = "awesome"}),

   -- Layout manipulation
   awful.key({ modkey, "Shift" }, "j",
      function () awful.client.swap.byidx( 1) end,
      {description = "swap with next client by index", group = "client"}),

   awful.key({ modkey, "Shift" }, "k",
      function () awful.client.swap.byidx( -1) end,
      {description = "swap with previous client by index", group = "client"}),

   -- my edits
   awful.key({ modkey, "Shift" }, "Left",
      function () awful.client.swap.bydirection("left") end,
      {description = "swap with next client by index", group = "client"}),

   awful.key({ modkey, "Shift" }, "Right",
      function () awful.client.swap.bydirection("right") end,
      {description = "swap with previous client by index", group = "client"}),

   awful.key({ modkey, "Shift" }, "Up",
      function () awful.client.swap.bydirection("up") end,
      {description = "swap with next client by index", group = "client"}),

   awful.key({ modkey, "Shift" }, "Down",
      function () awful.client.swap.bydirection("down") end,
      {description = "swap with previous client by index", group = "client"}),

   -- awful.key({ modkey, ctrlkey }, "j",
   --    function () awful.screen.focus_relative( 1) end,
   --    {description = "focus the next screen", group = "screen"}),

   -- awful.key({ modkey, ctrlkey }, "k",
   --    function () awful.screen.focus_relative(-1) end,
   --    {description = "focus the previous screen", group = "screen"}),

   awful.key({ modkey, }, "u",
      awful.client.urgent.jumpto,
      {description = "jump to urgent client", group = "client"}),

   awful.key({ modkey, }, "Tab",
      function ()
         awful.client.focus.history.previous()
         if client.focus then
            client.focus:raise()
         end
      end,
      {description = "go back to previously focused client", group = "client"}),

   -- Standard program
   awful.key({ modkey, }, "Return",
      function () spawn(terminal) end,
      {description = "Terminal", group = "launcher"}),

   awful.key({ modkey, }, "g",
      awful.tag.history.restore,
      {description = "View previous tag", group = "tag"}),

   awful.key({ modkey, altkey }, "r",
      awesome.restart,
      {description = "reload awesome", group = "awesome"}),

   awful.key({ modkey, "Shift" }, "q",
      awesome.quit,
      {description = "quit awesome", group = "awesome"}),

   awful.key({ modkey, }, "l",
      function () awful.tag.incmwfact( 0.03 ) end,
      {description = "increase master width factor", group = "layout"}),

   awful.key({ modkey, }, "h",
      function () awful.tag.incmwfact(-0.03) end,
      {description = "decrease master width factor", group = "layout"}),

   awful.key({ modkey, "Shift" }, "h",
      function () awful.tag.incnmaster( 1, nil, true) end,
      {description = "inc the number of master clients", group = "layout"}),

   awful.key({ modkey, "Shift" }, "l",
      function () awful.tag.incnmaster(-1, nil, true) end,
      {description = "dec the number of master clients", group = "layout"}),

   awful.key({ modkey, ctrlkey }, "h",
      function () awful.tag.incncol( 1, nil, true) end,
      {description = "increase the number of columns", group = "layout"}),

   awful.key({ modkey, ctrlkey }, "l",
      function () awful.tag.incncol(-1, nil, true) end,
      {description = "decrease the number of columns", group = "layout"}),

   awful.key({ modkey, altkey }, "l",
      function () awful.tag.incmwfact( 0.01) end,
      {description = "increase master width factor 1", group = "layout"}),

   awful.key({ modkey, altkey }, "h",
      function () awful.tag.incmwfact(-0.01) end,
      {description = "decrease master width factor 1", group = "layout"}),

   awful.key({ modkey }, "space",
      function () awful.layout.inc(-1) end,
      {description = "select previous", group = "layout"}),

   -- my_shortcuts {{
   awful.key({ modkey }, "b",
      function () spawn(browser) end,
      {description = "Browser", group = "launcher"}),

   awful.key({ modkey, "Shift" }, "b",
      function () spawn(private_browser) end,
      {description = "Browser", group = "launcher"}),

   awful.key({ modkey, }, "e",
      function () spawn(file_manager) end,
      {description = "filemanager", group = "launcher"}),

   awful.key({ modkey, }, "'",
      function () spawn(terminal) end,
      {description = "Terminal", group = "launcher"}),

   awful.key({ modkey, }, "r",
      function () spawn("emacsclient -c") end,
      {description = "Emacs", group = "launcher"}),

   awful.key({ modkey, altkey }, "j",
      function () awful.client.incwfact( 0.05) end,
      {description = "increase client size vertically", group = "client"}),

   awful.key({ modkey, altkey }, "k",
      function () awful.client.incwfact(-0.05) end,
      {description = "decrease client size vertically", group = "client"}),

   -- awful.key({ modkey, altkey }, "Right",
   --    function () awful.tag.incmwfact( 0.05) end,
   --    {description = "increase master width factor", group = "layout"}),

   -- awful.key({ modkey, altkey }, "Left",
   --    function () awful.tag.incmwfact(-0.05) end,
   --    {description = "decrease master width factor", group = "layout"}),

   awful.key({ modkey, }, "i",
      function () spawn("xdman") end,
      {description = "xdm", group = "launcher"}),

   -- {{ Music
   awful.key({ modkey, }, "x",
      function () spawn("lollypop --play-pause") end,
      {description = "toggle play / launch lollypop", group = "lollypop"}),

   awful.key({ modkey, }, ".",
      function () spawn("lollypop --next") end,
      {description = "play next", group = "lollypop"}),

   awful.key({ modkey, }, ",",
      function () spawn("lollypop --prev") end,
      {description = "play previous", group = "lollypop"}),

   awful.key({ modkey, }, "s",
      function () spawn(dmenu_dir .. "lollypop.pl") end,
      {description = "Add song to playlist", group = "launcher"}),

   -- awful.key({ modkey, }, "x",
   --    function () spawn("quodlibet --play-pause --run") end,
   --    {description = "toggle play / quodlibet", group = "quodlibet"}),

   -- awful.key({ modkey, }, ".",
   --    function () spawn("quodlibet --next --run") end,
   --    {description = "play next", group = "quodlibet"}),

   -- awful.key({ modkey, }, ",",
   --    function () spawn("quodlibet --previous --run") end,
   --    {description = "play previous", group = "quodlibet"}),

   -- awful.key({ modkey, altkey }, ".",
   --    function () spawn("quodlibet --seek=+00:10") end,
   --    {description = "Seek 10 seconds", group = "quodlibet"}),

   -- awful.key({ modkey, altkey }, ",",
   --    function () spawn("quodlibet --seek=-00:10") end,
   --    {description = "Seek -10 seconds", group = "quodlibet"}),

   awful.key({ modkey, }, "a",
      function () spawn(rofi_dir .. "applaunch/launcher.sh") end,
      {description = "rofi", group = "launcher"}),

   awful.key({ modkey, }, "d",
      function () spawn(dmenu_dir .. "brightness.pl") end,
      {description = "Control brightness", group = "brightness"}),

   awful.key({ modkey, }, "v",
      function () spawn(dmenu_dir .. "volume.pl") end,
      {description = "Control volume", group = "volume"}),

   awful.key({ modkey, altkey }, "e",
      function () spawn(dmenu_dir .. "emoji.pl") end,
      {description = "Emoji select", group = "launcher"}),

   awful.key({ modkey, altkey }, "v",
      function () spawn(dmenu_dir .. "greenclip.pl") end,
      {description = "Greenclip dmenu", group = "launcher"}),

   awful.key({ modkey, altkey }, "p",
      function () spawn("rofi -show calc -modi calc -no-sort") end,
      {description = "Rofi calc mode", group = "launcher"}),

   awful.key({ modkey, "Shift" }, "v",
      function () spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle") end,
      {description = "Mute volume ", group = "launcher"}),

   awful.key({ modkey, altkey }, "b",
      function () spawn(dmenu_dir .. "browser.pl") end,
      {description = "Browser menu ", group = "launcher"}),

   -- awful.key({ modkey, }, "q",
   --    function () spawn(color_picker) end,
   --    {description = "Color Picker", group = "launcher"}),

   -- awful.key({ modkey, }, "p", function () spawn("zathura") end,
   --    {description = "Zathura", group = "launcher"}),

   awful.key({ modkey, }, "[",
      function () spawn("blueberry") end,
      {description = "Bluetooth manager", group = "launcher"}),

   awful.key({ modkey, }, "]",
      function () spawn("/mnt/projects/Git/extra/boomer/boomer") end,
      {description = "Boomer", group = "launcher"}),

   awful.key({ modkey, altkey }, "[",
      function () spawn("killall blueberry") end,
      {description = "kill Bluetooth applet", group = "kill"}),

   awful.key({ }, "Print",
      function () spawn(scripts_dir .. "full-screenshot") end,
      {description = "capture a screenshot", group = "screenshot"}),

   awful.key({ ctrlkey }, "Print",
      function () spawn(scripts_dir .. "window-screenshot") end,
      {description = "take screenshot of active window", group = "screenshot"}),

   awful.key({ altkey }, "Print",
      function () spawn(scripts_dir .. "area-screenshot") end,
      {description = "take screenshot of selection", group = "screenshot"}),

   awful.key({ "Shift" }, "Print", function () spawn(scripts_dir .. "ocr") end,
      {description = "Get OCR text of selection to", group = "screenshot"}),

   -- modkey + altkey combination of screenshot related keybindings
   awful.key({ modkey, altkey }, "f",
      function () spawn(scripts_dir .. "full-screenshot") end,
      {description = "capture a screenshot", group = "screenshot"}),

   awful.key({ modkey, altkey }, "w",
      function () spawn(scripts_dir .. "window-screenshot") end,
      {description = "take screenshot of active window", group = "screenshot"}),

   awful.key({ modkey, altkey }, "a",
      function () spawn(scripts_dir .. "area-screenshot") end,
      {description = "take screenshot of selection", group = "screenshot"}),

   awful.key({ modkey, altkey }, "g",
      function () spawn(scripts_dir .. "ocr") end,
      {description = "Get OCR text of selection to", group = "screenshot"}),

   awful.key({ modkey }, "Print",
      function () spawn(rofi_dir .. "screenshot/launcher.sh") end,
      {description = "screenshot rofi menu", group = "screenshot"}),

   awful.key({ modkey }, "=",
      function () spawn(dmenu_dir .. "theme.pl") end,
      {description = "dmenu for switching themes", group = "launcher"}),

   awful.key({ modkey }, "-",
      function () spawn(dmenu_dir .. "powermenu.pl") end,
      {description = "powermenu", group = "launcher"}),

   awful.key({ modkey, "Shift" }, "c",
      function (c) spawn("xkill") end,
      {description = "xkill", group = "kill"}),

   -- Finer control over brightness and volume via Ctrl-Alt keybindings
   -- Pressing Ctrl-Alt kebindings is kinda hassle,
   -- to overcome this I am using kmonad (https://github.com/kmonad/kmonad)
   -- via kmonad config, When you hold down capslock it act as holding Ctrl+Alt
   -- the following keybindings are now easily pressable
   -- Brightness min/max
   awful.key({ modkey, altkey, ctrlkey }, "a",
      function() spawn_and_notify("xbacklight -set 100", "Brightness 100") end,
      {description = "Set brightness to max", group = "brightness"}),
   awful.key({ modkey, altkey, ctrlkey }, "e",
      function() spawn_and_notify("xbacklight -set 1", "Brightness 1") end,
      {description = "Set brightness to min", group = "brightness"}),

   -- Brightness 10%
   awful.key({ modkey, altkey, ctrlkey }, "c",
      function()
         spawn_and_notify("xbacklight -dec 10", "Brightness ", get_brightness)
      end,
      {description = "Decrease brightness 10%", group = "brightness"}),
   awful.key({ modkey, altkey, ctrlkey }, "i",
      function()
         spawn_and_notify("xbacklight -inc 10", "Brightness ", get_brightness)
      end,
      {description = "Increase brightness 10%", group = "brightness"}),

   -- Brightness 5%
   awful.key({ modkey, altkey, ctrlkey }, ",",
      function()
         spawn_and_notify("xbacklight -dec 5", "Brightness ", get_brightness)
      end,
      {description = "Decrease brightness 5%", group = "brightness"}),
   awful.key({ modkey, altkey, ctrlkey }, ".",
      function()
         spawn_and_notify("xbacklight -inc 5", "Brightness ", get_brightness)
      end,
      {description = "Increase brightness 5%", group = "brightness"}),

   -- Volume min/max
   awful.key({ modkey, altkey, ctrlkey }, "k",
      function() spawn_and_notify(volume .. " -set 100", "Volume 100") end,
      {description = "Set volume to max", group = "volume"}),
   awful.key({ modkey, altkey, ctrlkey }, "j",
      function() spawn_and_notify(volume .. " -mute", "Volume mute toggle") end,
      {description = "Toggles mute", group = "volume"}),

   -- Volume 10%
   awful.key({ modkey, altkey, ctrlkey }, "g",
      function()
         spawn_and_notify(volume .. " -dec 10", "Volume ", volume .. " -get")
      end,
      {description = "Decrease volume 10%", group = "volume"}),
   awful.key({ modkey, altkey, ctrlkey }, "x",
      function()
         spawn_and_notify(volume .. " -inc 10", "Volume ", volume .. " -get")
      end,
      {description = "Increase volume 10%", group = "volume"}),

   -- Volume 5%
   awful.key({ modkey, altkey, ctrlkey }, "-",
      function()
         spawn_and_notify(volume .. " -dec 5", "Volume ", volume .. " -get")
      end,
      {description = "Decrease volume 5%", group = "volume"}),
   awful.key({ modkey, altkey, ctrlkey }, "/",
      function()
         spawn_and_notify(volume .. " -inc 5", "Volume ", volume .. " -get")
      end,
      {description = "Increase volume 5%", group = "volume"}),

   -- Other shortcuts
   awful.key({ modkey, altkey, ctrlkey }, "t",
      function() spawn_and_notify("killall java", "Killed XDM") end,
      {description = "Kill XDM", group = "Kill"}),

   awful.key({ modkey, altkey, ctrlkey }, "s",
      function() spawn_and_notify("killall Discord", "Killed Discord") end,
      {description = "Kill Discord", group = "Kill"}),

   awful.key({ modkey, altkey, ctrlkey }, "'",
      function() spawn("firefox /mnt/projects/Git/undoo-startpage/src/index.html") end,
      {description = "Homepage", group = "launcher"}),
      -- End Other shortcuts
      -- End finer controls

      -- Show/Hide Wibox
      awful.key({ modkey }, "z", function ()
         for s in screen do
            -- set the name in the bar.lua
            s.mywibar.visible = not s.mywibar.visible
         end
   end,
      {description = "toggle wibox", group = "awesome"}),

   -- my_shortcuts ends }}

   awful.key({ modkey, ctrlkey }, "n",
      function ()
         local c = awful.client.restore()
         -- Focus restored client
         if c then
            client.focus = c
            c:raise()
         end
      end,
      {description = "restore minimized", group = "client"}),

   -- Menubar
   awful.key({ modkey }, "y", function() menubar.show() end,
      {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
   awful.key({ modkey, }, "f",
      function (c)
         c.fullscreen = not c.fullscreen
         c:raise()
      end,
      {description = "toggle fullscreen", group = "client"}),

   awful.key({ modkey, }, "c", function (c) c:kill() end,
      {description = "close", group = "client"}),

   awful.key({ modkey, ctrlkey }, "space", awful.client.floating.toggle,
      {description = "toggle floating", group = "client"}),

   awful.key({ modkey, }, ";",
      function (c) c:swap(awful.client.getmaster()) end,
      {description = "move to master", group = "client"}),

   -- awful.key({ modkey, }, "o",
   --    function (c) c:move_to_screen()                 end,
   --    {description = "move to screen", group = "client"}),

   awful.key({ modkey, }, "t", function (c) c.ontop = not c.ontop end,
      {description = "toggle keep on top", group = "client"}),

   awful.key({ modkey, }, "n",
      function (c)
         -- The client currently has the input focus, so it cannot be
         -- minimized, since minimized clients can't have the focus.
         c.minimized = true
      end,
      {description = "minimize", group = "client"}),

   awful.key({ modkey, }, "m",
      function (c)
         c.maximized = not c.maximized
         c:raise()
      end,
      {description = "(un)maximize", group = "client"}),

   awful.key({ modkey, ctrlkey }, "m",
      function (c)
         c.maximized_vertical = not c.maximized_vertical
         c:raise()
      end,
      {description = "(un)maximize vertically", group = "client"}),

   awful.key({ modkey, "Shift" }, "m",
      function (c)
         c.maximized_horizontal = not c.maximized_horizontal
         c:raise()
      end,
      {description = "(un)maximize horizontally", group = "client"}),

   awful.key({ modkey }, "o", keychord {
         a = function() awful.spawn(terminal) end,
         b = function() awful.spawn(scripts_dir .. "bt-keychron-kmonad") end,
         k = function() awful.spawn(scripts_dir .. "keychron-kmonad") end,
         t = function() awful.spawn(scripts_dir .. "theme -t") end,
         u = function() awful.spawn(scripts_dir .. "stringman -c clean_url") end,
         x = function() awful.spawn(scripts_dir .. "xrandr-toggle") end,
    })
)

clientbuttons = gears.table.join(
   awful.button({ }, 1,
      function (c) client.focus = c; c:raise() mymainmenu:hide() end),
   awful.button({ modkey }, 1, awful.mouse.client.move),
   awful.button({ ctrlkey }, 1, awful.mouse.client.resize)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.

local np_map = { 87, 88, 89, 83, 84, 85, 79, 80, 81 }
for i = 1, 9 do
   globalkeys = gears.table.join(
      globalkeys,
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
      awful.key({ modkey, altkey }, "#" .. np_map[i],
         function ()
            local screen = awful.screen.focused()
            if client.focus then
               local tag = client.focus.screen.tags[i]
               if tag then
                  client.focus:move_to_tag(tag)
               end
            end
            local tag = screen.tags[i]
            if tag then
               tag:view_only()
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
      awful.key({ modkey, altkey }, "#" .. i + 9,
         function ()
            local screen = awful.screen.focused()
            if client.focus then
               local tag = client.focus.screen.tags[i]
               if tag then
                  client.focus:move_to_tag(tag)
               end
            end
            local tag = screen.tags[i]
            if tag then
               tag:view_only()
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
         {description = "move focused client to tag #"..i, group = "tag"})
   )
end

return globalkeys
