#!/bin/bash

###############
# PREPARATION #
###############

flag=1
choice=1

##############
# USER INPUT #
##############

while [ $flag == 1 ]
do
        while [ $choice == 1 ]
        do
                lsblk
                echo " " ; echo "Where do you want to install mOS?" ; echo " "
                read ssd

                lenght=${#ssd}

                if [ $lenght != 8 ]
                then
                        echo " " ; echo "Wrong answer... try again." ; echo " "
                else
                        choice=0
                fi
        done

        choice=1

        while [ $choice == 1 ]
        do
                echo " " ; echo "Type in password for root:" ; echo " "
                read rootpwd

                lenght=${#rootpwd}

                if [ $lenght < 5 ]
                then
                        echo " " ; echo "Password is too small... try again." ; echo " "
                else
                        choice=0
                fi
        done

        choice=1

        while [ $choice == 1 ]
        do
                echo " " ; echo "Type in desired username:" ; echo " "
                read username

                lenght=${#username}

                if [ $lenght < 3 ]
                then
                        echo " " ; echo "Username is too small... try again." ; echo " "
                else
                        choice=0
                fi
        done

        choice=1

        while [ $choice == 1 ]
        do
                ls /sys/firmware/efi/efivars
                echo " " ; echo "Is this an EFI or BIOS motherboard? ('0' for BIOS, '1' for EFI) (If no directory is found, it's BIOS)" ; echo " "
                read efi

                if [ $efi != 1 ] && [ $efi != 0 ]
                then
                        echo " " ; echo "Wrong answer... try again." ; echo " "
                else
                        choice=0
                fi
        done

        choice=1

        userpwd=$rootpwd

        while [ $choice == 1 ]
        do
                echo " " ; echo "Which CPU is this PC using? (Type '0' for AMD, '1' for Intel)" ; echo " "
                read cpu_choice

                if [ $cpu_choice != 1 ] && [ $cpu_choice != 0 ]
                then
                        echo " " ; echo "Wrong answer... try again." ; echo " "
                else
                        choice=0
                fi
        done

        choice=1

        while [ $choice == 1 ]
        do
                echo " " ; echo "Which GPU is this PC using? (Type '0' for AMD, '1' for Intel, and '2' for nVidia)" ; echo " "
                read gpu_choice

                if [ $gpu_choice != 0 ] && [ $gpu_choice != 1 ] && [ $gpu_choice != 2 ]
                then
                        echo " " ; echo "Wrong answer... try again." ; echo " "
                else
                        choice=0
                fi
        done

        choice=1

        while [ $choice == 1 ]
        do
                echo " " ; echo "Are you sure that this info you entered is correct? Do you want to continue with installation? (Type '0' to continue, '1' to enter all information again):" ; echo " "
                read flag

                if [ $flag != 1 ] && [ $flag != 0 ]
                then
                        echo " " ; echo "Wrong answer... try again." ; echo " "
                else
                        choice=0
                fi
        done
done

#########
# SETUP #
#########

set -o pipefail

sudo pacman -Syy --noconfirm

timedatectl set-ntp true

################
# PARTITIONING #
################

if [ $efi == 1 ]
then
        boot_n="1"
        boot_size="+512M"
        boot_type="EF00"

        swap_n="2"
        swap_size="+8192M"
        swap_type="8200"

        root_n="3"
        root_size="+30G"
        root_type="8304"

        home_n="4"
        home_type="8302"

        sgdisk -p $ssd
        sgdisk -o $ssd
        sgdisk -n $boot_n:0G:$boot_size -t $boot_n:$boot_type -g $ssd
        sgdisk -n $swap_n:0G:$swap_size -t $swap_n:$swap_type -g $ssd
        sgdisk -n $root_n:0G:$root_size -t $root_n:$root_type -g $ssd
        sgdisk -n $home_n:0G -t $home_n:$home_type -g $ssd
else
        bios_boot_n="1"
        bios_boot_size="+1M"
        bios_boot_type="EF02"

        boot_n="2"
        boot_size="+512M"
        boot_type="EF00"

        swap_n="3"
        swap_size="+8192M"
        swap_type="8200"

        root_n="4"
        root_size="+30G"
        root_type="8304"

        home_n="5"
        home_type="8302"

        sgdisk -p $ssd
        sgdisk -o $ssd
        sgdisk -n $bios_boot_n:0:$bios_boot_size -t $bios_boot_n:$bios_boot_type -g $ssd
        sgdisk -n $boot_n:0G:$boot_size -t $boot_n:$boot_type -g $ssd
        sgdisk -n $swap_n:0G:$swap_size -t $swap_n:$swap_type -g $ssd
        sgdisk -n $root_n:0G:$root_size -t $root_n:$root_type -g $ssd
        sgdisk -n $home_n:0G -t $home_n:$home_type -g $ssd
fi

###################
# FORMATTING DISK #
###################

1="1"
2="2"
3="3"
4="4"
5="5"

if [ $efi == 1 ]
then
        temp="$ssd$1"
        mkfs.fat -F32 $temp
        temp=""

        temp="$ssd$3"
        mkfs.ext4 $temp
        temp=""

        temp="$ssd$4"
        mkfs.ext4 $temp
        temp=""

        temp="$ssd$2"
        mkswap $temp
        swapon $temp
        temp=""

        temp="$ssd$3"
        mount $temp /mnt
        mkdir /mnt/boot ; mkdir /mnt/home
        temp=""

        temp="$ssd$1"
        mount $temp /mnt/boot
        temp=""

        temp="$ssd$4"
        mount $temp /mnt/home
else
        temp="$ssd$2"
        mkfs.ext4 $temp
        temp=""

        temp="$ssd$4"
        mkfs.ext4 $temp
        temp=""

        temp="$ssd$5"
        mkfs.ext4 $temp
        temp=""

        temp="$ssd$3"
        mkswap $temp
        swapon $temp
        temp=""

        temp="$ssd$4"
        mount $temp /mnt
        mkdir /mnt/boot ; mkdir /mnt/home
        temp=""

        temp="$ssd$1"
        mount $temp /mnt/boot
        temp=""

        temp="$ssd$5"
        mount $temp /mnt/home
fi

################
# INSTALLATION #
################

internet="broadcom-wl curl firefox flashplugin icedtea-web networkmanager nftables openssh reflector transmission-gtk webkit2gtk wget youtube-dl network-manager-applet wireless_tools wpa_supplicant"
multimedia=" alsa alsa-utils android-file-transfer ciano ffmpeg kamoso kdeconnect kphotoalbum mpc mpd strawberry pavucontrol spectacle sxiv vlc"
utilities=" acpi alacritty alsa-lib alsa-plugins ark bleachbit blueberry blueman bluez-tools bluez-utils cdrdao cdrtools cmake cups cups-pdf dbus dialog dmidecode doublecmd-gtk2 dvd+rw-tools ttf-font-awesome fuseiso gnu-free-fonts gparted grub gxkb gzip hardinfo htop iw k3b kcron libtool libxft libxinerama linux-hardened mtpfs nautilus neofetch p7zip pacman-contrib picom psensor pulseaudio-bluetooth python python-pipenv python-pyalsa python3 redshift testdisk udiskie unrar unzip vim xorg-server xorg-xinit zip mesa"
text=" bookworm calibre calligra gedit gedit-plugins libreoffice-still man-db man-pages mcomix paperwork texinfo zathura zathura-pdf-mupdf"
security=" speedcrunch sudo korganizer kronometer livewallpaper pulseaudio pulseaudio-alsa jack jack2"
codecs=" wavpack a52dec celt lame libmad libmpcdec opus libvorbis opencore-amr speex libdca faac faad2 libfdk-aac jasper libwebp aom dav1d rav1e schroedinger libdv x264 x265 libde265 libmpeg2 xvidcore libtheora libvpx fdkaac"

efi=" efibootmgr"

essential=" base base-devel linux linux-firmware"
desktopenv=" lxqt breeze-icons sddm" # OR xfce4; config sddm manager...

cpu_intel=" intel-ucode"
cpu_amd=" amd-ucode"

                                                                # DRIVERS
gpu_intel=" xf86-video-intel vulkan-intel"                      # 32bit: lib32-vulkan-intel
gpu_amd=" xf86-video-ati xf86-video-amdgpu vulkan-radeon"       # 32bit: lib32-amdvlk lib32-vulkan-radeon
gpu_nvidia=" nvidia nvidia-utils"                               # 32bit: lib32-nvidia-utils
                                                                # 32bit: lib32-alsa-plugins lib32-libpulse lib32-openal libunrar lib32-libxinerama lib32-mesa

mos="$internet$multimedia$utilities$text$security$codecs$essential$desktopenv"

if [ $efi == 1 ]
then
        mos="$efi"
else
        something=1
fi

if [ $cpu_choice == 1 ]
then
        mos="$cpu_intel"
else
        mos="$cpu_amd"
fi

if [ $gpu_choice == 0 ]
then
        mos="$gpu_amd"
else
        something=1
fi

if [ $gpu_choice == 1 ]
then
        mos="$gpu_intel"
else
        something=1
fi

if [ $gpu_choice == 2 ]
then
        mos="$gpu_nvidia"
else
        something=1
fi

pacstrap /mnt $mos

cd /mnt
git clone https://github.com/windwalk-bushido/Atina.git

genfstab -U /mnt >> /mnt/etc/fstab

array=(0 $ssd $efi $rootpwd $username $userpwd) # For me, everything starts with '1'...
cd /mnt ; mkdir note
cd /mnt/note ; touch file.txt
echo "$array" > file.txt

arch-chroot /mnt