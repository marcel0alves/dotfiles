# Set keyboard to br-thinkpad
setxkbmap -layout us -model dell -variant intl

# Start X
xrandr --output eDP1 --mode 1920x1080 --rate 59.93
xsetroot -cursor_name left_ptr
exec bspwm
