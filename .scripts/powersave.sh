#!/bin/sh
# Set powersave governor for CPU.

echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
echo "Disabled Turbo Boost."

for c in $(ls -d /sys/devices/system/cpu/cpu[0-9]*); do echo powersave >$c/cpufreq/scaling_governor; done
echo "Changed to Powersave CPU governor."
echo "Done!"
