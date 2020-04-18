#!/bin/sh
xpid="$(pgrep -n X)"
xuser="$(ps -o user --no-headers $xpid)"
display="$(egrep -aoz ':[0-9](.[0-9])?' /proc/$xpid/cmdline)"
export XAUTHORITY="/home/$xuser/.Xauthority"
export DISPLAY="$display"

su - "$xuser" -c /home/$xuser/.scripts/lock ; echo mem > /sys/power/state
