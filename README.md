# my config for awesome window manager

+ Git repo on Codeberg: <https://codeberg.org/anhsirk0/awesome-config>
  - Mirrors:
    + GitHub: <https://github.com/anhsirk0/awesome-config>

## Features
Very Minimal - no fancy effects, no fancy widgets, not even icons (all the themes follow same pattern)  
Modular (mostly) - Different files for keybindings, rules, rc.lua  
Rofi Scripts for some Useful tasks - control Volume, Brightness, Wifi, Emoji, BrowserMenu, Lollypop music  
Rofi Scripts moved to its own [repo](https://codeberg.org/anhsirk0/rofi-config)  
Themes are divided in 2 groups (`themes` and `old_themes`)  
Total 42 themes (8 modus themes) (36 modus themes) (8 old themes)  
Old themes will no longer be maintained  

## Screenshots
Ef-themes pictures: https://protesilaos.com/emacs/ef-themes-pictures  

### Modus-Operandi & Modus-Vivendi theme
[![operandi-vivendi.png](https://i.postimg.cc/sD2PkW0F/operandi-vivendi.png)](https://postimg.cc/mh0FMPsV)

### Ef-Summer & Ef-Winter theme
[![summer-winter.png](https://i.postimg.cc/v8hL2hhL/summer-winter.png)](https://postimg.cc/qgt3z89z)

### Ef-Spring & Ef-Autumn theme
[![spring-autumn.png](https://i.postimg.cc/QtrkwnvS/spring-autumn.png)](https://postimg.cc/gwNZ64z6)

### Ef-Trio light & dark theme
[![trio-light-dark.png](https://i.postimg.cc/1Xm05Vmq/trio-light-dark.png)](https://postimg.cc/1ndVvtNm)

### Ef-Tritanopia light & dark theme
[![tritanopia-light-dark.png](https://i.postimg.cc/DZddTPTh/tritanopia-light-dark.png)](https://postimg.cc/MMHj0RH3)

### Ef-Bio & Ef-Cherie theme
[![bio-cherie.png](https://i.postimg.cc/VN0D3tvs/bio-cherie.png)](https://postimg.cc/TyGVbpnB)

## Following themes are now part of `old_themes`
### Moonlight theme
![moonlight.png](https://i.postimg.cc/bJqgm404/moonlight.png)

### Aqua theme
![aqua.png](https://i.postimg.cc/654rf9Jy/aqua.png)

### Pastel theme
![pastel1.png](https://i.postimg.cc/Tw8Mh26g/pastel1.png)
![pastel2.png](https://i.postimg.cc/SQfFNptY/pastel2.png)

### Warm theme
![warm1.png](https://i.postimg.cc/qq0PXmg7/warm1.png)
![warm2.png](https://i.postimg.cc/025gzHLW/warm2.png)

### One-dark theme
![onedark1.png](https://i.postimg.cc/3wvzMMvR/onedark1.png)
![onedark2.png](https://i.postimg.cc/1XHLWpNr/onedark2.png)

### Gruv theme
![gruv1.png](https://i.postimg.cc/FK3CWjMk/gruv1.png)
![gruv2.png](https://i.postimg.cc/d19HvJtq/gruv2.png)

### Boxes theme
![boxes2.png](https://i.postimg.cc/sgFpntsK/boxes2.png)

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
Same themes are also avalable for Alacritty, rofi and Kakoune in my [alacritty-themes](https://codeberg.org/anhsirk0/alacritty-themes), [rofi-config](https://codeberg.org/anhsirk0/rofi-config) and [kakoune-themes](https://codeberg.org/anhsirk0/kakoune-themes) repo respectively  
modified from awesome-copycats

## Thanks
Modus themes - https://protesilaos.com/emacs/modus-themes-colors  
Ef themes - https://protesilaos.com/emacs/ef-themes  
