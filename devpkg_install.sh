#!/bin/bash
##########################################################################################
# DONT TOUCH FOLLOWING SCRIPTS
##########################################################################################
source common.sh
readonly LOGPREFIX="Dev Pkg. Install"


#Check sudo
progress_log $LOGPREFIX "Check Root permission"
if [ $EUID -ne 0 ]; then
   error_log "You must execute this script with sudo command: sudo bash $0"
	exit 1
fi

#VS Code/Edge/Teams Install
if ! which code >> /dev/null; then
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main"
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main"
    apt update
    apt upgrade -y
    apt install -y code microsoft-edge-stable teams
    success_log "install Code, Edge, Teams done..."
fi

#install GTKterm
if ! which gtkterm >> /dev/null; then
    apt install -y gtkterm
    usermod -a -G dialout $INSTALL_USER
    success_log "install gtkterm done..."
fi

#install fancy-git, https://github.com/diogocavilha/fancy-git
curl -sS https://raw.githubusercontent.com/diogocavilha/fancy-git/master/install.sh | sh

##disable time
fancygit --suggested-global-git-config-apply
fancygit --disable-time
fancygit --enable-host-name

success_log "Finish all set-up done! need reboot now!"

