#!/bin/bash
##########################################################################################
# DONT TOUCH FOLLOWING SCRIPTS
##########################################################################################
readonly ETHERNET_DRV="intel-e1000e-3.8.7"
readonly LOG_PREFIX="HPZBookFury15G8"

function install_model_drivers() {
    local ethernet_path="$1/$ETHERNET_DRV"

	#install ethernet drvier
    progress_log $LOG_PREFIX "Ethernet driver($ETHERNET_DRV) install start..."
    if [ -d "$ethernet_path" ]; then
        
        success_log "$ETHERNET_DRV install done.."
    else
        error_log  "Cant found $ethernet_path..."
    fi

    #install graphics-driver via ubuntu-driver autoinstall
    progress_log $LOG_PREFIX "Graphics driver install start... $NVIDIA_DRV_VERSION"
    add-apt-repository ppa:graphics-drivers/ppa -y
    if [ "$NVIDIA_DRV_VERSION" == "autoinstall" ]; then
        ubuntu-drivers autoinstall
        NvidiaVersion=`ubuntu-drivers devices | grep recommended | awk -F' ' '{print $3}'`
        apt install -y $NvidiaVersion    
    else
        apt install -y nvidia-driver-$NVIDIA_DRV_VERSION
        NvidiaVersion=nvidia-driver-$NVIDIA_DRV_VERSION
    fi
    apt-mark hold $NvidiaVersion
    
    if [ $? -eq 0 ]; then
        success_log "$NvidiaVersion Graphics driver install done.."
    else
        error_log "$NvidiaVersion Graphics driver install fail.."
    fi
    return 0
}
