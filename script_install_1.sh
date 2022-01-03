#!/bin/bash

clear

echo -en "\e[1;32m █████╗ ██████╗  ██████╗██╗  ██╗        ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ \n"
		echo -en "██╔══██╗██╔══██╗██╔════╝██║  ██║        ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗\n"
		echo -en "███████║██████╔╝██║     ███████║        ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝\n"
		echo -en "██╔══██║██╔══██╗██║     ██╔══██║        ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗\n"
		echo -en "██║  ██║██║  ██║╚██████╗██║  ██║        ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║\n"
		echo -en "╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝        ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝\n\n"

echo -en "Welcome to Arch Install Script\nBefore Installing, make sure you have\n\e[1;31m1. Set proper keyboard layout\n2. Created partitions before installation\n3. Installed reflector and selected proper mirror\n"

########################
####____Timezone____####
########################

timezn="Asia/Kolkata"
echo -en "\e[0;0mSet timezone: \e[0;32m[Default = Asia/Kolkata]\e[1;31m\n"
read buf
if [[ ! -z "$buf" ]]; then
	timezn=$buf
fi 
echo -en "\e[0;32mTimezone set to $timezn\n"

########################
####___partitions__#####
########################

dri="nvme0n1"
part="1"
dri_b="nvme0n1p1"
dri_s="nvme0n1p2"
dri_r="nvme0n1p3"
dri_h="nvme0n1p4"
echo -en "\e[1;31mBoot Drive: \e[0;32m[Default nvme0n1p1] \e[1;31m (*only supports sdx and nvme)\e[1;0m\n"
read buf
if [[ "$buf" == *nvme* ]] && [[ ! -z "$buf" ]]; then
	dri=$( echo $buf | sed 's/.\{2\}$//' )
	part=$( echo $buf | sed 's/^.\{8\}//' )
	dri_b=$buf
elif [[ "$buf" == *sd* ]] && [[ ! -z "$buf" ]]; then
	dri=$( echo $buf | sed 's/.$//' )
	part=$( echo $buf | sed 's/^...//' )
	dri_b=$buf
fi
echo -en "\e[0;32mBoot drive set to $dri_b\n"

echo -en "\e[1;31mSwap Drive: \e[0;32m[Default nvme0n1p2]\e[1;0m\n"
read buf
if [[ ! -z "$buf" ]]; then
	dri_s=$buf
fi
echo -en "\e[0;32mSwap drive set to $dri_s\n"

echo -en "\e[1;31mRoot Drive: \e[0;32m[Default nvme0n1p3]\e[1;0m\n"
read buf
if [[ ! -z "$buf" ]]; then
	dri_r=$buf
fi
echo -en "\e[0;32mRoot drive set to $dri_r\n"

echo -en "\e[1;31mHome Drive: \e[0;32m[Default nvme0n1p4]\e[1;0m\n"
read buf
if [[ ! -z "$buf" ]]; then
	dri_h=$buf
fi
echo -en "\e[0;32mHome drive set to $dri_h\n"

##############################
########___home___############
##############################
for_hom="n"
echo -en "\e[0;32mFormat Home partition[y/n]? [Default n]\n\e[0;0m"
read buf
while [[ ! "$buf" == "n" ]] && [[ ! "$buf" == "y" ]]; do
	echo -en "[y/n]:"
	read buf
done
for_hom=$buf


###############################
#####____Kernel, ucode____#####
###############################
linux="linux"
ucode="amd-ucode"
echo -en "\e[0;32mLinux kernel to install \e[1;32m[Default = linux]:\e[0;0m"
read buf
if [[ ! -z "$buf" ]]; then
	linux=$buf
fi
echo -en "\e[0;32mUcode to install \e[1;32m[Default = amd-ucode]:\e[0;0m"
read buf
if [[ ! -z "$buf" ]]; then
	ucode=$buf
fi
echo -en "\e[1;32mKernel: $linux    Ucode: $ucode\n"


###############################
####____locale ,hostname___####
###############################
loc="en_IN.UTF-8"
echo -en "\e[0;32mSet locale \e[1;32m[Default en_IN.UTF-8]:\e[0;0m"
read buf
if [[ ! -z "$buf" ]]; then
	loc=$buf
fi

echo -en "\e[0;32mSet Hostname:\e[0;0m"
read buf
while [[ -z "$buf" ]]; do
	echo -en "\e[0;32mSet Hostname:\e[0;0m"
	read buf
done
host=$buf

###############################
#####____user, passwd____######
###############################
echo -en "\e[0;32mSet root password:\e[0;0m"
read buf
while [[ -z "$buf" ]]; do
	echo -en "\e[0;32mSet root password:\e[0;0m"
	read buf
done
rpas=$buf


echo -en "\e[0;32mSet username:\e[0;0m"
read buf
while [[ -z "$buf" ]]; do
	echo -en "\e[0;32mSet username:\e[0;0m"
	read buf
done
user=$buf

echo -en "\e[0;32mSet password:\e[0;0m"
read buf
while [[ -z "$buf" ]]; do
	echo -en "\e[0;32mSet password:\e[0;0m"
	read buf
done
pas=$buf

#############################
#######____my cfg___#########
#############################
echo -en "\e[1;31mInstall my personal prefs? [y/n]:\e[0;0m"
read buf
while [[ ! "$buf" == "y" ]] && [[ ! "$buf" == "n" ]]; do
	echo -en "[y/n]:"
	read buf
done
my=$buf



###############################
#####____Check Options___######
###############################
clear

echo -en "\n\n"

echo -en "\e[1;32m ██████╗██╗  ██╗███████╗ ██████╗██╗  ██╗         ██████╗ ██████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗\n"
		echo -en "██╔════╝██║  ██║██╔════╝██╔════╝██║ ██╔╝        ██╔═══██╗██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝\n"
		echo -en "██║     ███████║█████╗  ██║     █████╔╝         ██║   ██║██████╔╝   ██║   ██║██║   ██║██╔██╗ ██║███████╗\n"
		echo -en "██║     ██╔══██║██╔══╝  ██║     ██╔═██╗         ██║   ██║██╔═══╝    ██║   ██║██║   ██║██║╚██╗██║╚════██║\n"
		echo -en "╚██████╗██║  ██║███████╗╚██████╗██║  ██╗        ╚██████╔╝██║        ██║   ██║╚██████╔╝██║ ╚████║███████║\n"
		echo -en " ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝         ╚═════╝ ╚═╝        ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝\n\n\e[0;0m"


echo -en "timezone = $timezn\n"
echo -en "Boot drive = $dri\tpart $part\tBoot-> $dri_b\tSwap-> $dri_s\tRoot-> $dri_r\tHome-> $dri_h\n"
echo -en "Format Home: $for_hom\n"
echo -en "Kernel: $linux\tUcode: $ucode\n"
echo -en "Locale: $loc\tHostname: $host\n"
echo -en "Root password: $rpas\n"
echo -en "Non root user: $user\tPassword: $pas\n"
echo -en "Install my prefs: $my\n"


###############################
######____Installing_____######
###############################

echo -en "\e[1;31mAre you sure to install with these parameters[y/n]:\e[0;0m"
read buf

while [[ ! "$buf" == "n" ]] && [[ ! "$buf" == "y" ]]; do
	echo -en "[y/n]:"
	read buf
done

if [[ "$buf" == "n" ]]; then
	echo "quitting script"
	sleep 1
	exit 0
fi

echo installing...
sleep 1

clear

echo -en "\e[1;32m██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ██╗███╗   ██╗ ██████╗ \n"
		echo -en "██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██║████╗  ██║██╔════╝ \n"
		echo -en "██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ██║██╔██╗ ██║██║  ███╗\n"
		echo -en "██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██║██║╚██╗██║██║   ██║\n"
		echo -en "██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗██║██║ ╚████║╚██████╔╝\n"
		echo -en "╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ \n\n\e[0;0m"

####################____TEST____#####################

# Time
timedatectl set-timezone $timezn
timedatectl set-ntp true

# Format
mkfs.vfat -F32 /dev/$dri_b
mkswap /dev/$dri_s
mkfs.ext4 /dev/$dri_r
if [[ "$for_hom" == "y" ]]; then
	mkfs.ext4 /dev/$dri_h
fi

# Mount
mount /dev/$dri_r /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/$dri_b /mnt/boot
mount /dev/$dri_h /mnt/home
swapon /dev/$dri_s

# Pacstrap
pacstrap /mnt base $linux linux-firmware $ucode base-devel vim vim-airline networkmanager nm-connection-editor wireless_tools bash-completion less

# Fstab
genfstab -U /mnt >> /mnt/etc/fstab

# copy next script
cp script_install_2.sh /mnt/root/

# Execute second script in chroot
arch-chroot /mnt /root/script_install_2.sh $timezn $loc $host $user $pas $rpas $linux $ucode $dri_r









