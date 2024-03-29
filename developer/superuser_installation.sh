#!/bin/bash




sudo timedatectl set-ntp true




git clone https://github.com/windwalk-bushido/Athena-Linux.git




git clone https://aur.archlinux.org/paru.git
mv paru .paru_aur_installer
cd .paru_aur_installer/
makepkg -sic --noconfirm
cd ~/




dev_apps="spectrwm ttf-font-awesome chromium htop curl fuseiso usbutils cmake dbus dialog man-db man-pages texinfo kcron testdisk gimp ranger calcurse xwallpaper termdown xlockmore xscreensaver ncdu virtualbox virtualbox-host-dkms openssh sshfs godot python-pygame rsync code ruby-sass typescript npm nodejs yarn python-pip python-pipenv python-pipreqs linux-headers" # python-redis redis postgresql postgresql-docs postgresql-libs pgadmin4 python-pg8000 python-psycopg2 python-pymongo python-mongomock feathernotes hardinfo docker docker-compose
pentest_apps="openvpn nmap metasploit hydra hashcat hashcat-utils john nikto perl-image-exiftool openbsd-netcat fcrackzip wireshark-qt socat"
programs="$dev_apps $pentest_apps"
sudo pacman -S $programs --noconfirm

dev_apps="timeshift nerd-fonts-complete" # ngrok heroku-cli mongodb-compass mongodb mongodb-tools-bin
pentest_apps="burpsuite gobuster enum4linux smbmap steghide"
programs="$dev_apps $pentest_apps"
paru -S $programs --noconfirm




sudo modprobe vboxdrv
sudo modprobe vboxnetadp
sudo modprobe vboxnetflt




cp -r Athena-Linux/developer/scrollbook .scrollbook
rm .scrollbook/32bit.sh
rm -r .scrollbook/dev/


rm .bashrc
cp Athena-Linux/developer/dotfiles/bashrc_superuser .bashrc


mkdir -p .psensor/
cp Athena-Linux/developer/dotfiles/psensor.cfg .psensor/


mkdir .screenlayout
cp Athena-Linux/developer/dotfiles/monitor.sh .screenlayout/
cp Athena-Linux/developer/dotfiles/laptop.sh .screenlayout/


mkdir .wallpaper
cp Athena-Linux/distro/files/wallpaper.png .wallpaper/


sudo cp Athena-Linux/distro/files/sysfiles/hosts /etc/hosts_old


mkdir -p .config/ranger/plugins/
git clone https://github.com/alexanderjeurissen/ranger_devicons .config/ranger/plugins/ranger_devicons
echo "default_linemode devicons" > .config/ranger/rc.conf


mkdir -p .config/picom/
cp Athena-Linux/developer/dotfiles/picom.conf .config/picom/


#bash Athena-Linux/developer/scrollbook/dev/install-WM-stack.sh
cp Athena-Linux/developer/dotfiles/spectrwm.conf .spectrwm.conf
echo "exec spectrwm" > .xinitrc




mkdir Music
mkdir Videos

mkdir Backup
mkdir Desktop
mkdir Documents
mkdir Downloads
mkdir Projects
mkdir Pictures




rm -r Athena-Linux

sudo pacman -Scc --noconfirm
paru -Scc --noconfirm
rm -r .cache/paru/clone




#reboot
