#!/bin/bash

options="$HOME/.config/rofi/screenshot/options.txt"
scripts_dir="$HOME/.config/myshell/scripts"
config="$HOME/.config/rofi/screenshot/config.rasi"

chosen=$(cat $options | rofi -p "Screenshot menu" -dmenu -i -config $config)

if [ ! -z "$chosen" ] ; then
    action=$(echo $chosen | awk '{print $1}')
    name=$(echo $chosen | awk '{print $2}')
    sleep 1
    case $action in
        a*)
            $scripts_dir/area_screenshot $name ;;
        w*)
            $scripts_dir/window_screenshot $name ;;
        *)
            bash /$scripts_dir/full_screenshot $name ;;
    esac
fi


