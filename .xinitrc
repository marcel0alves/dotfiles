# Load a resource file
# [[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Set keyboard to us-intl
setxkbmap -layout us -model dell -variant intl

# Set 60Hz in monitor
xrandr --output eDP-1 --mode 1920x1080 --rate 60.01

# Enable Num Lock at Startx
numlockx 

# Start Openbox
exec openbox
