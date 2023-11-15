#!/bin/bash

##########################################################################################
# Please modified following values for each machine
##########################################################################################
source common.sh
readonly LOGPREFIX="EA15.2-Install"
WINE_SUPPORTED_UBUNTU_VER=(
   "23.04"
   "22.10"
   "22.04"
   "20.04"
)
WINE_REPO_NAMES=(
   "https://dl.winehq.org/wine-builds/ubuntu/dists/lunar/winehq-lunar.sources"
   "https://dl.winehq.org/wine-builds/ubuntu/dists/kinetic/winehq-kinetic.sources"
   "https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources"
   "https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources"
)

MACH_UBUNTU_VER="UNKNOWN"
TARGET_WINE_REPO="UNKNOWN"
EA_INSTALL_FILE="easetupfull152.msi"

function usage() {
   echo "Usage : ./enterprise_arch_install.sh <path of $EA_INSTALL_FILE>"
}

progress_log "$LOGPREFIX" "USER permission check"
if [ $EUID -eq 0 ]; then
   error_log "You must execute this script without sudo command.."
   usage
	exit 1
fi

#Check installer exist
if [ $# -ne 1 ]; then
   error_log "need $EA_INSTALL_FILE file path..."
   usage
   exit 1
fi

EA_INSTALLER_PATH=$1
progress_log $LOGPREFIX "Checking $EA_INSTALLER_PATH file..."
if [ ! -f $EA_INSTALLER_PATH ]; then
   error_log "can't find $EA_INSTALL_FILE..."
   exit 1
fi

progress_log $LOGPREFIX "Checking Ubuntu Compatibility ..."

#### refer : https://sparxsystems.com/enterprise_architect_user_guide/15.2/product_information/enterprise_architect_linux.html
# Install Wine : https://wiki.winehq.org/Ubuntu
#Compatibility Check
for i in "${!WINE_SUPPORTED_UBUNTU_VER[@]}"; do
   if [[ $(lsb_release -r) =~ "${WINE_SUPPORTED_UBUNTU_VER[i]}" ]]; then
      MACH_UBUNTU_VER=${WINE_SUPPORTED_UBUNTU_VER[i]}
      TARGET_WINE_REPO=${WINE_REPO_NAMES[i]}
   fi
done

if [ "$MACH_UBUNTU_VER" == "UNKNOWN" ]; then
   error_log "Not support version, this script is just supported ${SUPPORTED_UBUNTU_VER[*]}"
   error_log "Your ubuntu version is $(lsb_release -r)"
   exit 1
fi

#Add Wine repo
sudo dpkg --add-architecture i386
#Add repo key
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
#add wine repo
sudo wget -NP /etc/apt/sources.list.d/ $TARGET_WINE_REPO
#install wine
sudo apt update
sudo apt install --install-recommends winehq-stable -y

#install Carlito font
sudo apt install fonts-crosextra-carlito -y

#download winetricks
if [ ! -f "winetricks" ]; then
   wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
   chmod +x winetricks
fi
#install msxml
progress_log $LOGPREFIX "winetricks will lanched to install msxml3, click install button in 'Wine mono manager' window "
./winetricks msxml3
progress_log $LOGPREFIX "winetricks will lanched to install msxml4, click install button in 'Wine mono manager' window "
./winetricks msxml4
progress_log $LOGPREFIX "winetricks will lanched to install mdac28, click install button in 'Wine mono manager' window "
./winetricks --force mdac28

./winetricks jet40

progress_log $LOGPREFIX "winecfg will lanched for add msado15 lib, choose libraries tab, add *msado15 and click OK.."
winecfg

#instal EA
wine msiexec /i $EA_INSTALLER_PATH