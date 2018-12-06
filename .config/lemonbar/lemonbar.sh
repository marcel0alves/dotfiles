#!/bin/sh
# 
# Created by Marcelo Alves. 
# No copyright. 

# Import pywal color scheme

. "${HOME}/.cache/wal/colors.sh"


# Brightness
brightness() {
	actual_brightness="$(cat /sys/class/backlight/intel_backlight/actual_brightness)"
	max_brightness="$(cat /sys/class/backlight/intel_backlight/max_brightness)"
	actual_percent="$(($actual_brightness * 100 / $max_brightness))"

	echo -n "\uf0df $actual_percent%"

}

# battery
battery() {
	capacity="$(</sys/class/power_supply/BAT0/capacity)"
	status="$(</sys/class/power_supply/BAT0/status)"

	echo -n "$capacity% $status"
}

# clock
clock() {
	DATETIME=$(date "+%A, %b %d %H:%M")

	echo -n "\uf0ed $DATETIME"
}

# Temp
coretemp() {
	coretemp="$(sensors | awk '/Core/ {print substr($3, 2, 2)}' | tr '\n' ' ' | sed 's/ /°C  /g' | sed 's/  $//')"

	echo -n "
}

# Wireless
wifi() {
	ssid="$(iw dev wlp3s0 link | awk '/SSID/ {printf $2 " " $3}')"
	ipwifi="$(ip -f inet -o addr show wlp3s0 | awk '{print $4}' | sed -r 's/\/.*//')"

	echo -n "\uf927 $ipwifi $ssid"
}

# Network
network() {
	ipnet="$(ip -f inet -o addr show enp2s0 | awk '{print $4}' | sed -r 's/\/.*//')"

	echo -n "\uf6f2 $ipnet"
}

# bspwm
bspwm() {
	BSPWM=$(bspc query -D --names)
	BUSY=$(bspc query -D -d .occupied)
	for DESK in $BSPWM
	do
		# CHAR="\uf12f"
		if [[ $BUSY =~ $DESK ]]
		then
			echo -n "$BSPWM"
			# CHAR="\uf130"
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
	echo -e "%{c}$(bspwm) %{r}$(wifi) $(network) $(brightness) $(battery) $(clock)"
	sleep .1
done

