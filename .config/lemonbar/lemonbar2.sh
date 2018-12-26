#!/usr/bin/env bash
# 
# Created by Marcelo Alves. 
# No copyright. 

# Import pywal color scheme

. "${HOME}/.cache/wal/colors.sh"

# All things. Enjoy it

datetime="$(date "+%A, %b %d %H:%M")"
clock="$(awk -F ': ' '/MHz/ {print substr ($2, 1, length($2)-4); exit}' /proc/cpuinfo | sed 's/$/ MHz/')"
coretemp="$(sensors | awk '/Core/ {print substr($3, 2, 2)}' | tr '\n' ' ' | sed 's/ /°C  /g' | sed 's/  $//')"
ipnet="$(ip -f inet -o addr show enp2s0 | awk '{print $4}' | sed -r 's/\/.*//')"
ipwifi="$(ip -f inet -o addr show wlp3s0 | awk '{print $4}' | sed -r 's/\/.*//')"
battery_status=`echo $(cat /sys/class/power_supply/BAT0/capacity ; cat /sys/class/power_supply/BAT0/status)`

# Brightness
brightness() {
	actual_brightness="$(cat /sys/class/backlight/intel_backlight/actual_brightness)"
	max_brightness="$(cat /sys/class/backlight/intel_backlight/max_brightness)"
	actual_percent="$(($actual_brightness * 100 / $max_brightness))"

	echo -n "\uf0df $actual_percent%"

}

datetime() {
	echo -n "$datetime"
}

clock() {
	echo -n "$clock"
}

coretemp() {
	echo -n "$coretemp"
}

ipnet() {
	echo -n "$ipnet"
}

ipwifi() {
	echo -n "$ipwifi"
}

battery_status() {
	echo -n "$battery_status"
}

# bspwm
bspwm() {
	BSPWM=$(bspc query -D)
	BUSY=$(bspc query -D -d .occupied)
	for DESK in $BSPWM
	do
		CHAR="\uf12f"
		if [[ $BUSY =~ $DESK ]]
		then
			CHAR="\uf130"
		fi
		echo -n "%{A:bspc desktop $DESK -f:}"
		if [ $DESK = $(bspc query -D -d) ]
		then
			echo -n "%{F#ccaa22}$CHAR%{F-}"
		else
			echo -n "$CHAR"
		fi
		echo -n "%{A} "
	done
}

while true; do
	echo -e "%{l} $(clock) \t \t $(coretemp) %{c} $(bspwm) %{r} $(ipwifi) $(ipnet) \t \t $(brightness) \t \t $(battery_status) \t \t $(datetime)"
	sleep .1
done
