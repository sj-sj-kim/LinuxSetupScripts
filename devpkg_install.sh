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

#Podman install
### Check nvidia driver
if ! which podman >> /dev/null; then
    progress_log $LOGPREFIX "Install Podman..."

    . /etc/os-release
    echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
    curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key | sudo apt-key add -
    apt update
    apt upgrade -y
    apt install -y podman
    success_log "install podman done..."
fi

#NVidia container toolkit install
dpkg -l | grep nvidia-container-toolkit
if [ $? -ne 0 ]; then
    progress_log $LOGPREFIX "Install NVidia container toolkit..."

    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
        && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    apt update
    apt upgrade -y
    apt install -y nvidia-container-toolkit
    sed -i 's/^#no-cgroups = false/no-cgroups = true/;' /etc/nvidia-container-runtime/config.toml

    HookFile=/usr/share/containers/oci/hooks.d/oci-nvidia-hook.json
    mkdir -p `dirname $HookFile`
    cat << EOF > $HookFile
    {
        "version": "1.0.0",
        "hook": {
            "path": "/usr/bin/nvidia-container-toolkit",
            "args": ["nvidia-container-toolkit", "prestart"],
            "env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            ]
        },
        "when": {
            "always": true,
            "commands": [".*"]
        },
        "stages": ["prestart"]
    }
EOF
END
    success_log "install NVidia Container-toolkit done..."
fi

#VS Code/Edge Install
if ! which code >> /dev/null; then
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main"
    apt update
    apt upgrade -y
    apt install -y code microsoft-edge-stable
    success_log "install Code, Edge done..."
fi

#install GTKterm
if ! which code >> /dev/null; then
    apt install -y gtkterm
    usermod -a -G dialout $INSTALL_USER
    success_log "install gtkterm done..."
fi

success_log "Finish all set-up done! need reboot now!"

