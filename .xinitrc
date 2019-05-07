# Set keyboard to us-intl
setxkbmap -layout us -model dell -variant intl

# Set 60Hz in monitor
xrandr --output eDP-1 --mode 1920x1080 --rate 60.01

# Enable Num Lock at Startx
numlockx 

# Enable mouse on bspwm
xsetroot -cursor_name left_ptr

# Start wm
exec bspwm
