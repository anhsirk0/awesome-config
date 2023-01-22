
--  ██████╗ ██████╗ ███████╗██████╗  █████╗ ███╗   ██╗██████╗ ██╗
-- ██╔═══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗████╗  ██║██╔══██╗██║
-- ██║   ██║██████╔╝█████╗  ██████╔╝███████║██╔██╗ ██║██║  ██║██║
-- ██║   ██║██╔═══╝ ██╔══╝  ██╔══██╗██╔══██║██║╚██╗██║██║  ██║██║
-- ╚██████╔╝██║     ███████╗██║  ██║██║  ██║██║ ╚████║██████╔╝██║
--  ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝

local colors         = {}

colors.wallpaper     = "#cfe2ff"
colors.bg_main       = "#ffffff"
colors.fg_main       = "#000000"
colors.bg_dim        = "#f8f8f8"
colors.fg_dim        = "#282828"
colors.bg_alt        = "#f0f0f0"
colors.fg_alt        = "#505050"
colors.bg_active     = "#d7d7d7"
colors.fg_active     = "#0a0a0a"
colors.bg_inactive   = "#efefef"
colors.fg_inactive   = "#404148"

colors.red           = "#a60000"
colors.orange        = "#f2b0a2"
colors.green         = "#005e00"
colors.green_alt     = "#145c33"
colors.yellow        = "#813e00"
colors.blue          = "#0031a9"
colors.blue_alt      = "#0000c0"
colors.purple        = "#721045"
colors.purple_alt    = "#8f0075"

-- reversed accent_alt & accent_alt because theme is light
colors.bg_accent_alt = "#d0d6ff"
colors.fg_accent_alt = colors.fg_main
colors.fg_accent     = colors.fg_active
colors.bg_accent     = colors.blue

return colors
