#!/bin/bash
sudo pacman -S --noconfirm xdg-user-dirs gvfs-mtp 
sudo pacman -S --noconfirm mesa mesa-demos mesa-utils xf86-video-amdgpu amdvlk 
sudo pacman -S --noconfirm xf86-input-evdev xf86-input-synaptics xf86-input-wacom xf86-input-libinput xorg xorg-xinit
sudo pacman -S --noconfirm i3-gaps rofi kitty python python3 python-pillow xss-lock
sudo pacman -S --noconfirm nitrogen neofetch 
sudo pacman -S --noconfirm alsa-utils pavucontrol pulseaudio pulseaudio-bluetooth bluez bluez-utils blueman 
sudo pacman -S --noconfirm wget 
sudo pacman -S --noconfirm ttf-font-awesome ttf-nerd-fonts-symbols ttf-droid ttf-liberation
sudo pacman -S --noconfirm vlc p7zip evince firefox gtk-chtheme lxappearance imagemagick cheese gtk2 gtk3 gtk4 adapta-gtk-theme ranger
sudo pacman -S --noconfirm cmus htop

yay -S polybar picom-ibhagwan-git pipes.sh i3lock-color betterlockscreen siji-git cava

exit 0

###############################################
##########___DellG5SE Fanctl___################
###############################################


mkdir -p Fan
cd Fan
wget https://github.com/DavidLapous/DellG5SE-Fan-Linux/archive/refs/tags/v3.3-2.zip
7z x ~/Fan/**
cd ~/Fan/DellG5SE-Fan-Linux-3.3-2/
g++ -std=c++20 -O3 -march=native -Wall DellFan.cpp -o DellFan
sudo cp DellFan /usr/bin/
sudo modprobe dell-smm-hwmon restricted=0 ignore_dmi=1
sudo modprobe ec_sys write_support=1
echo -e "# This file must be at /etc/modules-load.d/\ndell-smm-hwmon\nec_sys" | sudo tee /etc/modules-load.d/dell-smm-hwmon.conf

echo -e "# This file must be at /etc/modprobe.d/\noptions dell-smm-hwmon restricted=0 ignore_dmi=1\noptions ec_sys write_support=1" | sudo tee /etc/modprobe.d/dell-smm-hwmon.conf
