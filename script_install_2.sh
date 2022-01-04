#!/bin/bash

# Set timezone
timedatectl set-timezone $1
timedatectl set-ntp true

# Generate locale
sed -i 's/#'$2'/'$2'/' /etc/locale.gen
locale-gen
echo "LANG=$2"  > /etc/locale.conf
export LANG=$2

# Setup hostname
echo "$3" > /etc/hostname
echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t$3.localdomain\t$3"

# Set root password
echo -e "$6\n$6" | passwd

# Add sudo user
useradd --create-home $4
echo -e "$5\n$5" | passwd $4
usermod -aG wheel $4
vim /etc/sudoers -c ':%s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/|:wq!'

# Install git and efibootmgr and bootloader
pacman -Syy --noconfirm git efibootmgr
bootctl --path=/boot install
cd /boot/loader/
echo -e "timeout 10\nconsole-mode keep\ndefault 01_arch.conf" >> loader.conf
cd entries
echo -e "title\tArch Linux" > 01_arch.conf
echo -e "linux\t/vmlinuz-$7" >> 01_arch.conf
echo -e "initrd\t/$8.img" >> 01_arch.conf
echo -e "initrd\t/initramfs-$7.img" >> 01_arch.conf
echo -e "options\troot=/dev/$9 rw" >> 01_arch.conf

echo -e "title\tArch Linux Fallback" > 02_arch-fallback.conf
echo -e "linux\t/vmlinuz-$7" >> 02_arch-fallback.conf
echo -e "initrd\t/$8.img" >> 02_arch-fallback.conf
echo -e "initrd\t/initramfs-$7-fallback.img" >> 02_arch-fallback.conf
echo -e "options\troot=/dev/$9 rw" >> 02_arch-fallback.conf

systemctl enable NetworkManager.service

cp /root/my.sh /home/$4/
