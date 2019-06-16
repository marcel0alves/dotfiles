#!/bin/sh
# Set powersave governor for CPU.

for c in $(ls -d /sys/devices/system/cpu/cpu[0-9]*); do echo powersave >$c/cpufreq/scaling_governor; done
echo "Done!"
