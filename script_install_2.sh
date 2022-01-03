#!/bin/bash

# Set timezone
/bin/timedatectl set-timezone $1
/bin/timedatectl set-ntp true

# Generate locale
sed -i 's/#'$2'/'$2'/' /etc/locale.gen
/bin/locale-gen
echo "LANG=$2"  > /etc/locale.conf
export LANG=$2

# Setup hostname
echo "$3" > /etc/hostname
echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\t$3.localdomain\t$3"

# Set root password
echo "$6" | /bin/passwd

# Add sudo user
useradd --create-home $4
echo $5 | /bin/passwd $4
usermod -aG wheel $4
vim /etc/sudoers -c ':%s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/|:wq!'

# Install git and efibootmgr and bootloader
pacman -Syy --noconfirm git efibootmgr
bootctl --path=/boot install
cd /boot/loader/
echo -e "timeout 10\ndefault 01_arch.conf"
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

################################################################################


echo "sudo pacman -S --noconfirm xdg-user-dirs gvfs-mtp mesa mesa-demos mesa-utils xf86-video-amdgpu amdvlk xf86-input-evdev xf86-input-synaptics xf86-input-wacom xf86-input-libinput xorg xorg-xinit i3-gaps rofi kitty python python3 xss-lock nitrogen neofetch alsa-utils pavucontrol pulseaudio pulseaudio-bluetooth bluez bluez-utils blueman wget ttf-font-awesome ttf-nerd-fonts-symbols ttf-droid ttf-liberation firefox vlc p7zip evince gtk-chtheme lxappearance imagemagick cheese gtk2 gtk3 gtk4 adapta-gtk-theme" > /home/$4/my

echo "yay -S polybar picom pipes.sh i3lock-color betterlockscreen siji-git" >> /home/$4/my

echo -en "\e[1;32mFinished"

