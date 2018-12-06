#!/bin/sh
#
# Suspend to RAM.
# Copyright is bullshit.


notify-send 'Testing' 'Suspending to RAM...' &&
su -c 'echo mem > /sys/power/state'
