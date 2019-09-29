# Set keyboard to br-thinkpad
setxkbmap -layout br -variant thinkpad

# Start X
xrandr --output eDP1 --mode 1366x768 --rate 60.00
xsetroot -cursor_name left_ptr
exec bspwm

