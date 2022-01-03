# arch-install-script-roxrudra
Easy basic arch install script
Download both scripts
Run the first script only
## It does not install secure boot
## It only installs systemd-boot


### It will install systemd-boot 
### If you want to just add a new entry to already installed boot drive,
### just comment out
### 1. mkfs.vfat -F32 /dev .... line
### 2. bootctl --path .... install line
### 3. echo ... loader.conf ... line
