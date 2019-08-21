#!/bin/sh

getvol () {

VOLU=$(amixer -M | head -5 | awk -F"[][]" '/dB/ { printf "%0.0f\n", $2 }')
STATUS=$(amixer sget Master | awk -F"[][]" '/dB/ { print $6 }')

if [ "$STATUS" = "off" ]; then
	VOL="mute"
elif [ "$VOLU" = "0" ]; then
	VOL="mute"
	else
	VOL="$VOLU"
fi
}

while

	getvol
	echo "$VOL"

do sleep 0.2
done
