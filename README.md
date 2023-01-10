# my config for awesome window manager

## Features
Themes are divided in 2 groups (`themes` and `old_themes`)  
Old themes will no longer be maintained  
Very Minimal - no fancy effects, no fancy widgets, not even icons (all the themes follow same pattern)  
Modular (mostly) - Different files for keybindings, rules, rc.lua  
Rofi Scripts for some Useful tasks - control Volume, Brightness, Wifi, Emoji, BrowserMenu, Lollypop music  
Rofi Scripts moved to its own [repo](https://github.com/anhsirk0/rofi-config)  

## Screenshots
### Ef-Cherie theme
![ef-cherie](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/ef-cherie.png)

### Ef-Spring theme
![ef-spring](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/ef-spring.png)

### Ef-Summer theme
![ef-summer](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/ef-summer.png)

### Ef-Bio theme
![ef-bio](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/ef-bio.png)

### Ef-Autumn theme
![ef-autumn](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/ef-autumn.png)

### Ef-Trio-Light theme
![ef-trio-light](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/ef-trio-light.png)

### Ef-Trio-Dark theme
![ef-trio-dark](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/ef-trio-dark.png)

### Ef-Winter theme
![ef-winter](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/ef-winter.png)

### Operandi theme
![operandi](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/operandi.png)

### Vivendi theme
![vivendi](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/vivendi.png)

## Following themes are now part of `old_themes`
### Moonlight theme
![moonlight](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/moonlight.png)

### Aqua theme
![aqua](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/aqua.png)

### Pastel theme
![pastel](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/pastel1.png)
![pastel](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/pastel2.png)

### Warm theme
![warm](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/warm1.png)
![warm](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/warm2.png)

### One-dark theme
![onedark](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/onedark1.png)
![onedark](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/onedark2.png)

### Gruv theme
![gruv](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/gruv1.png)
![gruv](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/gruv2.png)

### Boxes theme
![boxes](https://github.com/anhsirk0/awesome-config/blob/master/screenshots/boxes2.png)

## change-theme.pl
use `scripts/change-theme.pl` to change the themes (fzf optionally required)
```bash
$ ~/.config/awesome/scripts/change-theme.pl 
```
> This will use fzf to select a theme (from ~/.config/awesome/themes) interactively (fzf)
```bash
$ ~/.config/awesome/scripts/change-theme.pl viv
'vivendi' theme selected
```
> This will change theme to the first theme that has viv in its name
```bash
$ ~/.config/awesome/scripts/change-theme.pl gruv
'gruv' theme selected
```
> This will change theme to the first theme that has gruv in its name, like gruvbox

## Some defaults info
Default font - [Iosevka Comfy](https://gitlab.com/protesilaos/iosevka-comfy)  
Newer themes are for resolution 1920x1080 while some are for 1366x768, change the font size, gaps etc etc accordingly  
Same themes are also avalable for Alacritty, rofi and Kakoune in my [alacritty-themes](https://github.com/anhsirk0/alacritty-themes), [rofi-config](https://github.com/anhsirk0/rofi-config) and [kakoune-themes](https://github.com/anhsirk0/kakoune-themes) repo respectively  
modified from awesome-copycats

## Thanks
Modus themes - https://protesilaos.com/emacs/modus-themes-colors  
Ef themes - https://protesilaos.com/emacs/ef-themes  
