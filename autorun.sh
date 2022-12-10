#!/bin/bash

## run (only once) processes which spawn with the same name
function run {
   if (command -v $1 && ! pgrep $1); then
     $@&
   fi
}

## run (only once) processes which spawn with different name
# if (command -v gnome-keyring-daemon && ! pgrep gnome-keyring-d); then
#     gnome-keyring-daemon --daemonize --login &
# fi
if (command -v start-pulseaudio-x11 && ! pgrep pulseaudio); then
    start-pulseaudio-x11 &
fi
if (command -v /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 && ! pgrep polkit-mate-aut) ; then
    /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
fi
if (command -v  xfce4-power-manager && ! pgrep xfce4-power-man) ; then
    xfce4-power-manager &
fi

# run nitrogen --restore
run nm-applet
# run picom --config ~/.config/compton.conf
run picom
# xmodmap ~/.config/awesome/swap_ctrl_alt
# kmonad ~/.config/awesome/mykmonadkeys.kbd
bash ~/.config/awesome/cursor_speed
xrdb -merge ~/.Xresources
run xss-lock -- betterlockscreen -l
run emacs --daemon &
notify-send "AwesomeWM Loaded"
