#!/bin/bash
set -ux
op=""
ff=""
md=""
echo "Creating enviroment..."
#chroot /mnt cat /etc/pacman.conf |grep -v multilib > pacman.conf2 && mv pacman.conf2 /etc/pacman.conf && echo '[multilib]' >> /etc/pacman.conf && echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf

cat /etc/pacman.conf |grep -v multilib > pacman.conf2 && mv pacman.conf2 /etc/pacman.conf && echo '[multilib]' >> /etc/pacman.conf && echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf

read -ep "Graphical system?(y/n)" gs
	if [[ $gs == y ]] || [[ $gs == Y ]]
		echo "Question graphical worked"
		then
			read -ep "Graphics manufacturer? (i)ntel, (a)md, (n)vidia)" drv
			echo "Question manuf worked"
			if [[ $drv == i ]]
			then 
				graphics="xf86-video-intel"
				echo "Intel worked"
			fi
			if [[ $drv == a ]]
			then	
				graphics="xf86-video-ati xf86-video-amdgpu"
			fi
			if [[ $drv == n ]]
			then
				read -ep "Install (p)roprietary or (f)ree driver?" ng
				if [[ $ng == p ]] || [[ $ng == P ]]
				then
					graphics=nvidia
				else
				graphics=xf86-video-nouveau
				fi

			fi
fi
read -ep "Do you want to install more than one browser?(y/N)" mtob
if [[ $mtob != "" ]]
then mtbo=n
fi
ffb=y
bins=0
read -ep "Install Firefox?(Y/n)" ffb
	if [[ $ffb == y ]] || [[ $ffb == Y ]]
	then
       		ff=firefox
		echo "Will install Firefox"
		if [[ mtob != y ]]
			then
			bins=1
		fi
	fi
if [[ $bins == 0 ]]
then
	read -ep "Install Opera?" opb
	if [[ $opb == y ]] || [[ $opb == Y ]]
	then
		op=opera
		if [[ mtob != y ]]
		then
			bins=1
		fi
	fi
fi

if [[ $bins == 0 ]]
then
	read -ep "Install Midori?" mdb
	if [[ $mdb == y ]] || [[ $mdb == Y ]]
	then
		md=midori
		if [[ mtob != y ]]
		then
			bins=1
		fi
	fi
fi

pacstrap /mnt base base-devel plasma dialog plasma-meta xfce4 xfce4-goodies kate git vim grub efibootmgr i3 os-prober sddm xorg-server $graphics networkmanager network-manager-applet plasma-nm kleopatra networkmanager-openvpn networkmanager-openconnect steam gparted $ff $op $md libreoffice-fresh okular hunspell-de hunspell-en kde-meta-kdeutils gnome-disk-utility pavucontrol paprefs arduino eclipse-java gwenview ristretto kolourpaint k3b xfburn vlc libvirt virtualbox virtualbox virtualbox-host-modules-arch veracrypt wine winetricks gwenview

echo "enabling multilib repository on new system..."
cat /mnt/etc/pacman.conf |sed s/"#[multilib]"/"[multilib]"/ > /mnt/etc/pacman.conf

cat /mnt/etc/pacman.conf |sed s/"#Include = /etc/pacman.d/mirrorlist"/"Include = /etc/pacman.d/mirrorlist"/ > /mnt/etc/pacman.conf

echo -e "\e[32mImportant packages installed and multilib enabled. Creating relevant folders now!\e[0m"
mkdir -v /mnt/home/$newusr
mkdir -v /mnt/home/$newusr/Downloads
mkdir -v /mnt/home/$newusr/Dokumente
mkdir -v /mnt/home/$newusr/Bilder
mkdir -v /mnt/home/$newusr/Videos
mkdir -v /mnt/home/$newusr/Downloads/pacaur
mkdir -v /mnt/home/$newusr/Downloads/cower

echo "User "$newusr" created with home folder and pacaur files in Downloads folder. Please define it with a password!!"
arch-chroot /mnt useradd -m -g users -s /bin/bash $newusr && passwd $newusr
arch-chroot /mnt echo "$newusr ALL=(ALL:ALL) ALL" > /etc/sudoers.d/$newusr
arch-chroot /mnt git clone https://aur.archlinux.org/pacaur.git /home/$newusr/Downloads/pacaur/
arch-chroot /mnt git clone https://aur.archlinux.org/cower.git /mnt/home/$newusr/Downloads/cower/
arch-chroot /mnt chown -R $newusr:users /home/$newusr
echo "Chrooting into the installed System in 10secs"
sleep 10
arch-chroot /mnt
