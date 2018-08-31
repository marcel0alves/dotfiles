# Load a resource file
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# Enable displays attached to the non-NVIDIA graphics
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto

# Set 60Hz in monitor
#xrandr --output eDP-1 --mode 1920x1080 --rate 60.01

# Set default keyboard us-intl
setxkbmap -layout us -model dell -variant intl

# Turn Num Lock on
numlockx

# Restore last coloscheme wal
wal -R

# Exec WM
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session bspwm
