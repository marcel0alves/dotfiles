#!/bin/bash

brightness_file=/sys/class/backlight/intel_backlight/brightness
brightness=$(< $brightness_file)

if [ $((brightness > 0)) '=' 1 ]
then
    brightness=$((brightness - 750))
    echo -n $brightness > $brightness_file
fi
