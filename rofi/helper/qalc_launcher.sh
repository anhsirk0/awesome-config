#!/bin/bash

dir="$HOME/.config/rofi/helper"

expr=$(rofi -p "Expression > " -dmenu -i -config $dir/config.rasi)

if [ -z "$expr" ] ; then
    exit
else
    ans=$(qalc "$expr")
    notify-send "$ans"
fi

