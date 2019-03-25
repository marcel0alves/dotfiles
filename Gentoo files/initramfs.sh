#!/bin/sh
# Create a custom initramfs.

# Creating the structure for initramfs
echo "Creating a basic initramfs directory structure. Default location: /usr/src/initramfs"
sleep 1
mkdir -p /usr/src/initramfs/{dev,mnt/root,proc,root,sys}

# Install required LUKS and GPG packages for initramfs
echo "Installing LUKS and GPG for initramfs."
sleep 1
USE="-* nettle argon2 static static-libs" CPU_FLAGS_X86="aes" emerge -av --root /usr/src/initramfs sys-fs/cryptsetup sys-apps/busybox '<app-crypt/gnupg-2.2'

# Create init
echo "Creating init."
sleep 1
cat > /usr/src/initramfs/init << EOF
#!/bin/busybox sh

rescue() {
        echo "Something went wrong. Dropping to a shell."
        exec setsid cttyhack sh
}

# Mount the /proc, /sys and /dev filesystems.
echo "Mounting necessary filesystems, please wait."
mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t sysfs none /sys
sleep 1

echo "Hello, good to see you. Starting your initramfs."

# Mount USB stick containing LUKS header and GPG key
echo "Mounting USB stick, please wait."
mkdir /mnt/usb
mount -o ro $(findfs UUID=6325-46BB) /mnt/usb || rescue

# Read password for gpg file
# The whole encryption is tried up for 3 times
I=1
NUMS="1 2 3"

for I in $NUMS
do
	echo "Enter password:"
	stty -echo
	read PASS 
	stty echo

	CRYPTSETUPPASS=""
	
# Decrypt gpg-file and pipe to cryptsetup
	CRYPTSETUPPASS=$(echo $PASS | gpg --decrypt --no-tty --passphrase-fd 0 /mnt/usb/luks-key.gpg)
	if [ "$?" -eq "0" ]; then
		echo "$PASS" | gpg --decrypt --no-tty --passphrase-fd 0 /mnt/usb/luks-key.gpg | cryptsetup --header /mnt/usb/header.img --key-file - open /dev/sdb1 gentoo && root=/dev/mapper/gentoo || rescue
		CRYPTSETUPPASS=""
		PASS=""
		break
	fi
done
stty echo </dev/console 

# Mounting rootfs
echo "Mounting Gentoo rootfs."
sleep 1
mount -o ro $(findfs UUID=734449bc-c50a-4f55-804d-89fa3dc77e3b) /mnt/root || rescue

# Cleaning up
echo "Some more adjustments"
umount /mnt/usb
umount /dev
umount /sys
umount /proc

# Boot Gentoo Linux
echo "If you see this, your Gentoo Linux is booting. See you later!"
sleep 1
exec switch_root /mnt/root /sbin/init
EOF

# Set init executable
echo "Setting init executable"
sleep 1
chmod +x /usr/src/initramfs/init

# Done.
echo "Initramfs created! Now check /usr/src/initramfs/init if everything is ok."
