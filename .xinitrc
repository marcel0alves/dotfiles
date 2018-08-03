[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xrandr --output eDP-1 --mode 1920x1080 --rate 60.01
setxkbmap -layout us -model dell -variant intl
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session i3
