#!/bin/bash
loadkeys de
echo "Creating enviroment..."
pacstrap /mnt base base-devel plasma plasma-meta xfce4 xfce4-goodies kate git vim grub efibootmgr i3 os-prober sddm xorg-server xf86-video-intel networkmanager network-manager-applet plasma-nm kleopatra networkmanager-openvpn networkmanager-openconnect steam gparted
echo "enabling multilib repository..."
cat /mnt/etc/pacman.conf |sed s/"#[multilib]"/"[multilib]"/ > /mnt/etc/pacman.conf
cat /mnt/etc/pacman.conf |sed s/"#Include = /etc/pacman.d/mirrorlist"/"Include = /etc/pacman.d/mirrorlist"/ > /mnt/etc/pacman.conf
echo -e "\e[32mImportant packages installed and multilib enabled. Have a nice day!\e[0m"

mkdir -v /mnt/home/sellerie
mkdir -v /mnt/home/sellerie/Downloads
mkdir -v /mnt/home/sellerie/Dokumente
mkdir -v /mnt/home/sellerie/Bilder
mkdir -v /mnt/home/sellerie/Videos
mkdir -v /mnt/home/sellerie/Downloads/pacaur
mkdir -v /mnt/home/sellerie/Downloads/cower

echo "sellerie:x:1000:100::/home/sellerie:/bin/bash" >> /mnt/etc/passwd
echo "sellerie:!!:17194:0:99999:7:::" >> /mnt/etc/shadow
git clone https://aur.archlinux.org/pacaur.git /mnt/home/sellerie/Downloads/pacaur/
git clone https://aur.archlinux.org/cower.git /mnt/home/sellerie/Downloads/cower
echo "User "sellerie" created with home folder and pacaur files in Downloads folder."

