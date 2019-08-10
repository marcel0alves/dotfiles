# Set keyboard to us-intl
setxkbmap -layout us -model dell -variant intl

# Enable Num Lock at Startx
numlockx 

# Start X
xrandr --output eDP-1 --mode 1920x1080 --rate 60.01
xsetroot -cursor_name left_ptr
exec bspwm
