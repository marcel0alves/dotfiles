#!/bin/sh
# Set performance governor for CPU.

echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
echo "Enabled Turbo Boost."

for c in $(ls -d /sys/devices/system/cpu/cpu[0-9]*); do echo performance >$c/cpufreq/scaling_governor; done
echo "Changed to Performance CPU governor."
echo "Done!"
