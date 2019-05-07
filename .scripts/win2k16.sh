#!/bin/sh
# Windows 10 VM.

# Path to Windows Server 2016 ISO
WIN2016ISO=~/ISO/Windows_Server_2016_Datacenter_EVAL_en-us_14393_refresh.ISO

# Path to VirtIO drivers
VIRTIOISO=~/ISO/virtio-win-0.1.164.iso

# Path to Windows Server 2016 HD
WIN2016=~/VirtualMachines/win2k16/win2k16.img

# Starting QEMU
qemu-system-x86_64 \
	-daemonize \
	-machine q35,accel=kvm -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
	-smp cores=1,threads=2 \
	-m 4G \
	-rtc clock=host,base=localtime \
	-vga none -device qxl-vga,vgamem_mb=32 \
	-serial none \
	-parallel none \
	-k en-us \
	-drive id=disk0,if=virtio,cache=none,format=qcow2,file=$WIN2016 \
	-net nic,macaddr=52:54:07:84:37:64 -net vde \
	-usb -device usb-tablet \
	-device virtio-serial-pci \
	-name "Windows Server 2016" 

sleep 0.5 ; echo "Windows Server 2016 started."
# spicy --class=win2016 --title="Windows Server 2016" 127.0.0.1 -p 5901 &

#	-drive file=$VIRTIOISO,index=1,media=cdrom \
#	-cdrom $WIN2016ISO -boot order=d \
#	-spice port=5901,addr=127.0.0.1,disable-ticketing \
# 	-chardev spicevmc,id=vdagent,name=vdagent \
# 	-device virtserialport,chardev=vdagent,name=com.redhad.spice.0 \


