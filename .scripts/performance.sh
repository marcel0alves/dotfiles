#!/bin/sh
# Set performance governor for CPU.

for c in $(ls -d /sys/devices/system/cpu/cpu[0-9]*); do echo performance >$c/cpufreq/scaling_governor; done
echo "Done!"
