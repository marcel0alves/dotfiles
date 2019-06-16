#!/bin/sh
# Check CPU governor.

cat /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor | tr '\n' ' ' | awk '{print $1}'
