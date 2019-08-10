#!/bin/sh
# Windows 10 VM.
set -x

# Paths
ISODIR=$HOME/VMs/ISO
VMDIR=$HOME/VMs
WIN10ISO=$ISODIR/win10_1809_x64.iso
VIRTIOISO=$ISODIR/virtio-win-0.1.164.iso
WIN10=$VMDIR/Win10/win10.img

# Starting QEMU
qemu-system-x86_64 \
	-daemonize \
	-machine q35,accel=kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
	-smp cores=1,threads=2 \
	-m 2G \
	-rtc clock=host,base=localtime \
	-vga none -device qxl-vga,vgamem_mb=32 \
	-serial none \
	-parallel none \
	-k en-us \
	-drive id=disk0,if=virtio,cache=none,format=qcow2,file=$WIN10 \
	-cdrom $WIN10ISO -boot order=d \
	-drive file=$VIRTIOISO,index=1,media=cdrom \
	-net nic,macaddr=52:54:17:fa:c0:7c -net vde \
	-usb -device usb-tablet \
	-device virtio-serial-pci \
	-name "Windows 10"

#	 spicy --class=win10 --title="Windows 10" 127.0.0.1 -p 5900 &


#	-drive file=$VIRTIOISO,index=1,media=cdrom \
#	-spice port=5900,addr=127.0.0.1,disable-ticketing \
#	-chardev spicevmc,id=vdagent,name=vdagent \
#	-device virtserialport,chardev=vdagent,name=com.redhad.spice.0 \
