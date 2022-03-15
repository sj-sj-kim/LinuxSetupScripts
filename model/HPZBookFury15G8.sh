#!/bin/bash
##########################################################################################
# DONT TOUCH FOLLOWING SCRIPTS
##########################################################################################
readonly ETHERNET_DRV="intel-e1000e-3.8.7"

function install_model_drivers() {
    local ethernet_path="$1/$ETHERNET_DRV"

	#install ethernet drvier
    progress_log "HPZBookFury15G8" "Ethernet driver($ETHERNET_DRV) install start..."
    if [ -d "$ethernet_path" ]; then
        
        success_log "$ETHERNET_DRV install done.."
    else
        error_log  "Cant found $ethernet_path..."
    fi

    #install graphics-driver via ubuntu-driver autoinstall
    progress_log "HPZBookFury15G8" "Graphics driver install start..."
: <<'END'
    add-apt-repository ppa:graphics-drivers/ppa -y
    ubuntu-drivers autoinstall
    NvidiaVersion=`ubuntu-drivers devices | grep recommended | awk -F' ' '{print $3}'`
    apt install -y $NvidiaVersion
END
    if [ $? -eq 0 ]; then
        success_log "Graphics driver install done.."
    else
        error_log "Graphics driver install fail.."
    fi
    return 0
}