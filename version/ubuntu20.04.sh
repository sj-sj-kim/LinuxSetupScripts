#!/bin/bash
##########################################################################################
# DONT TOUCH FOLLOWING SCRIPTS
##########################################################################################
function install_default_pkgs() {
apt-get update -q
apt-get upgrade -q
apt-get install -q -y \
    software-properties-common apt-transport-https wget build-essential vim curl \
    ubuntu-drivers-common wget git cmake doxygen graphviz openjdk-17-jre pv net-tools \
    exfat-fuse exfat-utils gtkterm language-pack-ko language-pack-gnome-ko-base \
    gnome-tweak-tool gnome-shell-extensions chrome-gnome-shell adapta-gtk-theme flat-remix \
    libcurl4 libnss3-tools terminator filezilla meld vlc sshfs remmina kolourpaint gdb-multiarch \
    tree sshpass git-lfs resolvconf

    return $?
}

function add_ms_repo() {
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main"    
    apt-get update -q
    apt-get install -q -y code microsoft-edge-stable
    return $?
}
