#!/bin/sh
# Script for create a custom initramfs.

# Creating the structure for initramfs
echo "Creating necessary directories and files structure. Default location: /usr/src/initramfs"
sleep 1
mkdir -p /usr/src/initramfs/{dev,mnt/root,proc,root,sys}

# Install required LUKS and GPG packages for initramfs
echo "Installing Busybox and LUKS for initramfs."
sleep 1
USE="-* nettle argon2 static static-libs" CPU_FLAGS_X86="aes" emerge --root /usr/src/initramfs sys-fs/cryptsetup sys-apps/busybox

# Create init
echo "Creating init."
sleep 1

cat > /usr/src/initramfs/init << EOF
#!/bin/busybox sh

clear ; sleep 1
echo "Hello again, good to see you. Starting your initramfs..."
echo "Mounting necessary filesystems."
mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t sysfs none /sys

sleep 1

echo "Mounting USB stick, please wait..."
mkdir -p /mnt/usb ; sleep 1
mount -o ro $(findfs UUID=6325-46BB) /mnt/usb || rescue

exec 0</dev/console
exec 1>/dev/console
exec 2>/dev/console

while :
do
	echo "Trying to open rootfs" ; sleep 1
	echo -e -n '\nEnter Password: "
	cryptsetup open --type plain -c aes-xts-plain64 -h sha512 -s 512 /mnt/usb/key.img key >/dev/null 2>&1 || rescue "Failed to open key file, dropping to a shell."
	cryptsetup -d /dev/mapper/key open --header /mnt/usb/root.img /dev/sdb1 gentoo >/dev/null 2>&1 || rescue "Failed to open rootfs, dropping to a shell."
	cryptsetup close /dev/mapper/key

	if [ -e "/dev/mapper/gentoo"] ; then
		echo "Mounting rootfs" ; sleep 1
		mount -o ro /dev/mapper/gentoo /mnt/root || Failed to mount rootfs, dropping to a shell."
		
		echo "Cleaning up" ; sleep 1
		umount /sys
		umount /proc
		
		echo "If you are reading this, your Gentoo Linux is booting. See you later!" ; sleep 1
		exec switch_root /mnt/root /sbin/init || rescue "Failed to boot Gentoo Linux, dropping to a shell."
	else
		sleep 2
		echo "Wrong password."
	fi
done


# Rescue shell
rescue() {
	echo "Something went wrong."
	exec setsid cttyhack sh
}
EOF
