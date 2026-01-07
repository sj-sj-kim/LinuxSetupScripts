#!/bin/bash
##########################################################################################
# DONT TOUCH FOLLOWING SCRIPTS
##########################################################################################
function install_default_pkgs() {
apt update -y
apt upgrade -y
apt install -y \
    software-properties-common apt-transport-https wget build-essential vim curl git pv tree sshpass ubuntu-drivers-common net-tools \
    python3 python3-pip python3-dev \
    sshfs exfatprogs libcurl4 libnss3-tools \
    cmake doxygen graphviz default-jre gdb-multiarch git-lfs \
    tilix gtkterm remmina meld vlc kolourpaint \
    gnome-tweaks gnome-shell-extensions gnome-browser-connector \
    language-pack-ko language-pack-gnome-ko-base ibus-hangul

    return $?
}

function add_ms_repo() {
    #add vscode repo
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    rm packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list

    #add edge repo
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft-edge.gpg
    install -D -o root -g root -m 644 microsoft-edge.gpg /etc/apt/keyrings/microsoft-edge.gpg
    rm microsoft-edge.gpg
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main" | tee /etc/apt/sources.list.d/microsoft-edge.list    
    #install packages
    apt-get update -q
    apt-get install -q -y code microsoft-edge-stable
    return $?
}

function set_hangul_key() {
    sudo -u $REAL_USER LANG=C xdg-user-dirs-update --force
    #ALT_R to hangul
    sudo -u $REAL_USER gsettings set org.gnome.desktop.input-sources xkb-options "['korean:ralt_hangul']"
    #CTL R to hanja
    sudo -u $SUDO_USER gsettings set org.gnome.desktop.input-sources xkb-options "['korean:ralt_hangul', 'korean:rctrl_hanja']"
    sudo -u $REAL_USER gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('ibus', 'hangul')]"
    return $?

}
