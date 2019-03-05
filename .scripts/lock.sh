#!/usr/bin/env bash
#
#  '||    //\   //'.  || /
#   ||   ||  | ||     ||x 
#   ||_|  \\/   \\_/ .|| \
#
# Description:              A minimal lock script
# Dependencies:             imagemagick, i3lock
# Optionnal dependencies:   notf
# Author:                   gawlk
# Contributors:             none

sleep 0.1

screenshot="/tmp/lock.png"

import -window root "$screenshot"
convert "$screenshot" -blur 0x8 "$screenshot"

i3lock -u -i $screenshot
