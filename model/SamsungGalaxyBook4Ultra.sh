#!/bin/bash
##########################################################################################
# DONT TOUCH FOLLOWING SCRIPTS
##########################################################################################
#readonly NVIDIA_DRV_VERSION="autoinstall"
readonly LOG_PREFIX="SamsungGalaxyBook4Ultra"
readonly NVIDIA_DRV_VERSION="530"

function install_graph_driver() {
    if [ "$NVIDIA_DRV_VERSION" == "autoinstall" ]; then
        NvidiaVersion=`ubuntu-drivers devices | grep recommended | awk -F' ' '{print $3}'`
        apt-get install -q -y $NvidiaVersion nvidia-prime nvidia-settings
    else
        apt-get install -q -y nvidia-driver-$NVIDIA_DRV_VERSION nvidia-prime nvidia-settings
        NvidiaVersion=nvidia-driver-$NVIDIA_DRV_VERSION 
    fi
    if [ $? -eq 0 ]; then
        success_log "$NvidiaVersion Graphics driver install done.."
        return 0
    else
        error_log "$NvidiaVersion Graphics driver install fail.."
        return 1
    fi
    
}

