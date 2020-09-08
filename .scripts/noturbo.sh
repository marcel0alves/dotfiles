#!/bin/sh
# Disable Intel Turbo Boost.

echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
echo "Disabled Turbo Boost."
