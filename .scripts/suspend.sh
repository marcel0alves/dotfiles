#!/bin/sh
#
# Suspend to RAM.
# Copyright is bullshit.

su -c 'echo mem > /sys/power/state'
