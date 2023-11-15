#!/bin/bash

##########################################################################################
# Please modified following values for each machine
##########################################################################################
source common.sh
readonly LOGPREFIX="Tweak. Install"

#Check sudo
progress_log $LOGPREFIX "Check Root permission"
if [ $EUID -ne 0 ]; then
   error_log "You must execute this script with sudo command: sudo bash $0"
	exit 1
fi

#### tweak & theme download refer : https://seonghyuk.tistory.com/168
add-apt-repository ppa:daniruiz/flat-remix -y
add-apt-repository ppa:tista/adapta -y
apt-get update -y
apt install gnome-tweak-tool gnome-shell-extensions chrome-gnome-shell adapta-gtk-theme flat-remix -y
	
success_log "install tweak done..."