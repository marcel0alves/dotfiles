#!/usr/bin/env bash

cputemp=$(sensors | awk '/Core/ {print substr ($3, 2, 2) " C"}' | tr '\n' ' ')

dunstify "CPU Temp" "${cputemp}"
#notify-send -u low "CPU Temp" "${cputemp}"
