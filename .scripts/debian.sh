#!/bin/sh
# Debian 9 Stretch WM

# Path to Debian ISO
DEBIANISO=~/ISO/debian-9.8.0-amd64-xfce-CD-1.iso

# Path to Debian HD
DEBIAN=~/VirtualMachines/debian/debian.img

# Starting QEMU
qemu-system-x86_64 \
	-daemonize \
	-machine q35,accel=kvm -cpu host \
	-smp cores=1,threads=1 \
	-m 1G \
	-rtc clock=host,base=localtime \
	-vga qxl \
	-serial none \
	-parallel none \
	-k en-us \
	-drive id=disk0,if=virtio,cache=none,format=qcow2,file=$DEBIAN \
	-net nic,macaddr=52:54:29:56:42:8c -net vde \
	-usb -device usb-tablet \
	-device virtio-serial-pci \
	-name "Debian 9"

sleep 0.5 ; echo "Debian 9 started."
#	spicy --class=debian --title="Debian 9" 127.0.0.1 -p 5902 &
# 	-cdrom $DEBIANISO -boot order=d \
#	-spice port=5902,addr=127.0.0.1,disable-ticketing \
#	-chardev spicevmc,id=vdagent,name=vdagent \
#	-device virtserialport,chardev=vdagent,name=com.redhad.spice.0 \

