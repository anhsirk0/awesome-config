#!/bin/bash

theme="config.rasi"
config="$HOME/.config/awesome/rofi/applaunch/$theme"

rofi -no-lazy-grab -show drun -modi drun -config $config
