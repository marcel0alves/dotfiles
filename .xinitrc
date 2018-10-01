# Load a resource file
[[ -f ~/.Xresources ]] && xrdb -I$HOME ~/.Xresources

# Set keyboard to us-intl
setxkbmap -layout us -model dell -variant intl

# Set 60Hz in monitor
xrandr --output eDP-1 --mode 1920x1080 --rate 60.01

# Start MPD daemon (if no other user instance exists)
[ ! -s ~/.config/mpd/pid ] && mpd

# Enable Num Lock at Startx
numlockx 

# Restore last colorscheme wal
wal -R

# Exec bspwm
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session bspwm
