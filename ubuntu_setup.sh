#!/bin/bash
##########################################################################################
# DONT TOUCH FOLLOWING SCRIPTS
##########################################################################################
MACH_UBUNTU_VER="UNKNOWN"
MACH_MODEL_NAME="UNKNOWN"
SUPPORTED_UBUNTU_VER=(
   "24.04"
   "20.04"
   "18.04"
)

SUPPORTED_COM_MODEL_FULL=(
   "HP ZBook Fury 15.6 inch G8 Mobile Workstation PC"
   "NT961XGL-X06/C"
)

SUPPORTED_COM_MODEL_SHORT=(
   "HPZBookFury15G8"
   "SamsungGalaxyBook4Ultra"
)

source common.sh

#Check sudo
progress_log "Ubuntu Setup" "Check Root permission"
if [ $EUID -ne 0 ]; then
   error_log "You must execute this script with sudo command: sudo bash $0"
	exit 1
fi

# 실제 로그인한 유저명 가져오기 (gsettings 설정용)
REAL_USER=$SUDO_USER
if [ -z "$REAL_USER" ]; then
  echo "Can't found SUDO_USER..."
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

#use local TZ for dual boot
timedatectl set-local-rtc 1 --adjust-system-clock

# update apt, apt repo, install some basic packages for set-up
progress_log "Ubuntu Setup" "Update basic packages..."
install_default_pkgs
if [ $? -ne 0 ]; then
   error_log "install_default_pkgs fail.."
   exit 1
fi

#Add microsoft repo
progress_log "Ubuntu Setup" "Install MicroSoft repo,packages..."
#add_ms_repo
#if [ $? -ne 0 ]; then
#   error_log "add_ms_repo fail.."
#   exit 1
#fi

#install slack
snap install slack --classic

#Add user group for tty
usermod -a -G dialout $INSTALL_USER

apt --fix-broken install
apt autoremove -y
apt autopurge -y
apt autoclean -y

success_log " Package update done...."

#install model specific driver
progress_log "Ubuntu Setup" "install $MACH_MODEL_NAME drivers..."
install_graph_driver
if [ $? -ne 0 ]; then
   error_log "install_graph_driver fail.."
   exit 1
fi

#hangul key
progress_log "Ubuntu Setup" "setup HANGUL keys..."
set_hangul_key

success_log "Finish all set-up done! need reboot now!"

