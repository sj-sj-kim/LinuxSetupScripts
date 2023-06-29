#!/bin/bash

##########################################################################################
# Please modified following values for each machine
##########################################################################################
source common.sh
readonly LOGPREFIX="Opt Utils. Install"

#Check sudo
progress_log $LOGPREFIX "Check Root permission"
if [ $EUID -ne 0 ]; then
   error_log "You must execute this script with sudo command: sudo bash $0"
	exit 1
fi

#### update language pack, home dir naming to eng
apt install -y language-pack-ko language-pack-gnome-ko-base
export LANG=C; xdg-user-dirs-gtk-update
success_log "language pack update done...."

#### tweak & theme download
add-apt-repository ppa:daniruiz/flat-remix -y
add-apt-repository ppa:tista/adapta -y
apt-get update -y
apt install gnome-tweak-tool gnome-shell-extensions chrome-gnome-shell adapta-gtk-theme flat-remix -y
	
success_log "install tweak done..."

#install VPN tools
wget https://dl.technion.ac.il/docs/cis/public/ssl-vpn/ps-pulse-ubuntu-debian.deb -P ./bins/pkg
apt install -y libcurl4 libnss3-tools && dpkg -i bins/pkg/ps-pulse-ubuntu-debian.deb

#install offline pkgs
dpkg -i bins/slack-desktop-4.29.149-amd64.deb

#install more..
apt install -y terminator filezilla meld vlc sshfs remmina kolourpaint gdb-multiarch

apt --fix-broken install
apt autoremove -y
apt autopurge -y
apt autoclean -y

success_log "Finish all set-up done! recommand reboot now!"