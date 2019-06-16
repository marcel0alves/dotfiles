#!/bin/sh
# Script for create a custom initramfs.

# Creating the structure for initramfs
echo "Creating necessary directories and files structure. Default location: /usr/src/initramfs"
sleep 1
mkdir -p /usr/src/initramfs/{dev,mnt/root,proc,root,sys}

# Install required LUKS and Busybox packages for initramfs
echo "Installing Busybox and LUKS for initramfs."
sleep 1
USE="-* nettle argon2 static static-libs" CPU_FLAGS_X86="aes" emerge -av --root /usr/src/initramfs sys-fs/cryptsetup sys-apps/busybox

# Create init
echo "Creating init."
sleep 1

cat > /usr/src/initramfs/init << EOF
#!/bin/busybox sh

sleep 1 ; clear

mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t sysfs none /sys

exec 0</dev/console
exec 1>/dev/console
exec 2>/dev/console

while :
do
        echo -e -n "\nPassword: "
	cryptsetup open /etc/key.img key >/dev/null 2>&1 && echo
	cryptsetup -d /dev/mapper/key --header /etc/header.img open /dev/sdb gentoo >/dev/null 2>&1
        status=$?
        
	cryptsetup close /dev/mapper/key
                        
	if [ -e "/dev/mapper/gentoo" ]; then
		mount -t ext4 -o noatime,nodiratime,defaults /dev/mapper/gentoo /mnt/root
		umount /sys
		umount /proc

		sleep 1 ; echo "Booting Gentoo Linux."
		exec switch_root /mnt/root /sbin/init
	
	else
		sleep 3
		echo "Failed."
	fi
done
EOF

chmod +x /usr/src/initramfs/init

echo "Done."
