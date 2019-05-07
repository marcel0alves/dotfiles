#!/bin/sh
# Script for create a custom initramfs.

# Creating the structure for initramfs
echo "Creating necessary directories and files structure. Default location: /usr/src/initramfs"
sleep 1
mkdir -p /usr/src/initramfs/{dev,mnt/root,proc,root,sys}

# Install required LUKS and GPG packages for initramfs
echo "Installing Busybox and LUKS for initramfs."
sleep 1
USE="-* nettle argon2 static static-libs" CPU_FLAGS_X86="aes" emerge -av --root /usr/src/initramfs sys-fs/cryptsetup sys-apps/busybox

# Create init
echo "Creating init."
sleep 1

cat > /usr/src/initramfs/init << EOF
#!/bin/busybox sh

sleep 1 ; clear

echo "Hello again, good to see you. Starting your initramfs..."
echo "Mounting necessary filesystems."

mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t sysfs none /sys

exec 0</dev/console
exec 1>/dev/console
exec 2>/dev/console

while :
do

        echo "Opening rootfs"

        # Ask for password to open key device
        echo -e -n "\nPassword: "
        cryptsetup --header /etc/header.img open /etc/key.img key >/dev/null 2>&1 && echo

        # Opening rootfs in LUKS container
        crypt_device="$(findfs UUID=92076f4c-9df6-4d45-94db-ce78a5da66e3)"
        cryptsetup --key-file /dev/mapper/key open $crypt_device gentoo >/dev/null 2>&1
        crypt_status=$?

        # Close key device and check for status
        cryptsetup close /dev/mapper/key
        case $crypt_status in
                0)
                        echo "Mounting rootfs"
                        mount -o ro /dev/mapper/gentoo /mnt/root

                        echo "Cleaning up"
                        umount /sys
                        umount /proc

                        echo "If you are reading this, your Gentoo Linux is booting. Have a nice day!" ; sleep 1
                        exec switch_root /mnt/root /sbin/init
                        ;;

                2)
                        echo "Bad password."
                        ;;

                *)
                        echo "Unknow error."
                        ;;

        esac

done
EOF

chmod +x /usr/src/initramfs/init
