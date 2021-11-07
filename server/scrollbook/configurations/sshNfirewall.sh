#!/bin/bash




sudo rm /etc/ssh/sshd_config
sudo cp ~/Athena-Linux/server/files/dotfiles/sshd_config /etc/ssh/
#sudo sed -i 's/Port X/Port Y/g' /etc/ssh/sshd_config
# Change port in '/etc/ssh/sshd_config' file.

sudo ufw default deny
#sudo ufw allow X 		# SSH
sudo ufw allow 53 		# DNS
sudo ufw allow 80 		# HTTP
sudo ufw allow 443		# HTTPS

sudo ufw enable 
sudo ufw status verbose

sudo systemctl enable --now sshd.service
