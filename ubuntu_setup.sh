#!/bin/bash
##########################################################################################
# DONT TOUCH FOLLOWING SCRIPTS
##########################################################################################
MACH_UBUNTU_VER="UNKNOWN"
MACH_MODEL_NAME="UNKNOWN"
SUPPORTED_UBUNTU_VER=(
   "20.04"
   "18.04"
)

SUPPORTED_COM_MODEL_FULL=(
   "HP ZBook Fury 15.6 inch G8 Mobile Workstation PC"
)

SUPPORTED_COM_MODEL_SHORT=(
   "HPZBookFury15G8"
)

source common.sh

#Check sudo
progress_log "Ubuntu Setup" "Check Root permission"
if [ $EUID -ne 0 ]; then
   error_log "You must execute this script with sudo command: sudo bash $0"
	exit 1
fi

#Compatibility Check
progress_log "Ubuntu Setup" "Start Compatibility Checking..."
for ver in "${SUPPORTED_UBUNTU_VER[@]}"; do
   if [[ $(lsb_release -r) =~ "$ver" ]]; then
      MACH_UBUNTU_VER=$ver
      break
   fi
done
if [ "$MACH_UBUNTU_VER" == "UNKNOWN" ]; then
   error_log "Not support version, this script is just supported ${SUPPORTED_UBUNTU_VER[*]}"
   error_log "Your ubuntu version is $(lsb_release -r)"
   exit 1
fi

COM_FULL_NAME="$(dmidecode | grep Name)"
for (( i=0; i<${#SUPPORTED_COM_MODEL_FULL[@]}; i++ )) do
   if [[ "$COM_FULL_NAME" =~ "${SUPPORTED_COM_MODEL_FULL[${i}]}" ]]; then
      MACH_MODEL_NAME="${SUPPORTED_COM_MODEL_SHORT[${i}]}"
      break
   fi
done
if [ "$MACH_MODEL_NAME" == "UNKNOWN" ]; then
   error_log "Not support computer model, this script is just supported ${SUPPORTED_COM_MODEL_FULL[*]}"
   error_log "Your ubuntu version is $COM_FULL_NAME"
   exit 1
fi

UBUNTU_VER_PATH="version/ubuntu$MACH_UBUNTU_VER.sh"
COM_MODEL_PATH="model/$MACH_MODEL_NAME.sh"

source $UBUNTU_VER_PATH
source $COM_MODEL_PATH

success_log "Compatibility check done.. $MACH_MODEL_NAME, $MACH_UBUNTU_VER"


# change HOSTNAME
progress_log "Ubuntu Setup" "Change Hostname to $HOSTNAME"
echo $HOSTNAME | tee /etc/hostname

# update apt, apt repo, install some basic packages for set-up
progress_log "Ubuntu Setup" "Update basic packages..."

#DONT UPGRADE LINUX-image,header
#apt-mark hold linux-headers-generic linux-image-generic linux-modules-generic linux-modules-extra-generic


apt update
apt upgrade -y
apt install -y software-properties-common apt-transport-https wget build-essential vim curl ubuntu-drivers-common wget git cmake doxygen graphviz openjdk-17-jre pv net-tools exfat-fuse exfat-utils

success_log " Package update done...."

#install model specific driver
progress_log "Ubuntu Setup" "install $MACH_MODEL_NAME drivers..."
install_model_drivers "$(pwd)/bins/driver"
if [ $? -ne 0 ]; then
   error_log "driver install fail..."
	exit 1
fi

success_log "Finish all set-up done! need reboot now!"

