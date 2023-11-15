#!/bin/bash
##########################################################################################
# DONT TOUCH FOLLOWING SCRIPTS
##########################################################################################
source common.sh
readonly LOGPREFIX="Dev Pkg. Install"


#Check sudo
#VS Code/Edge/Teams Install
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main"
#sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main"
sudo apt update
sudo apt upgrade -y
sudo apt install -y code microsoft-edge-stable
success_log "install Code, Edge, Teams done..."

#install GTKterm
if ! which gtkterm >> /dev/null; then
    apt install -y gtkterm
    usermod -a -G dialout $INSTALL_USER
    success_log "install gtkterm done..."
fi

#install fancy-git, https://github.com/diogocavilha/fancy-git
curl -sS https://raw.githubusercontent.com/diogocavilha/fancy-git/master/install.sh | sh

##disable time


success_log "Finish all set-up done! need reboot now!"

