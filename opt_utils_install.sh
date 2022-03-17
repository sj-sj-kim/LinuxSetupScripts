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
apt install gnome-tweak-tool chrome-gnome-shell adapta-gtk-theme flat-remix -y
	
success_log "install tweak done..."

#install offline pkgs
dpkg -i bins/pkg/slack-desktop-4.24.0-amd64.deb

#install more..
apt install -y terminator filezilla

apt --fix-broken install
apt autoremove -y
apt autopurge -y
apt autoclean -y

success_log "Finish all set-up done! recommand reboot now!"