#!/usr/bin/env sh
#
#

# bar sh
bar="$(~/.config/lemonbar/launch.sh)"

# Kill bar
killall -q lemonbar

# Wait the bar shut down
while pgrep -u $UID -x lemonbar >/dev/null; do sleep 1; done

# Launch bar
sh $bar
