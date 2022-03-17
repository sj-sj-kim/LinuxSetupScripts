#!/bin/bash
##########################################################################################
# Please modified following values for each machine
##########################################################################################
readonly HOSTNAME="sungjun-linux"
readonly GIT_NAME="Kim SungJun"
readonly GIT_EMAIL="sungjun.kim@stradvision.com"
readonly DEFAULT_GITCONFIG="default.gitconfig"
readonly NVIDIA_DRV_VERSION="autoinstall"

##########################################################################################
# DONT TOUCH FOLLOWING SCRIPTS
##########################################################################################
readonly COLOR_RED="\033[31m"
readonly COLOR_GRN="\033[32m"
readonly COLOR_BLU='\e[0;34m'
readonly COLOR_DEFAULT="\033[0m"



function progress_log() {
   local tag=$1
	local prefix="$COLOR_BLU[$tag] $COLOR_DEFAULT"
	local str=$2
	echo -e "$prefix$str"
}

function error_log() {
	local err_prefix="$COLOR_RED[ERROR] $COLOR_DEFAULT"
	local err_str=$1
	echo -e "$err_prefix$err_str"
}

function success_log() {
	local prefix="$COLOR_GRN[Success] $COLOR_DEFAULT"
	local str=$1
	echo -e "$prefix$str"
}

function check_string_matching() {
	local src_str=$1
	local tgt_str=$2
	ret=1

	#echo "in check_string src:$1 tgt:$2"
	if [[ "$tgt_str" =~ "$src_str" ]]; then
		ret=0
	fi
	return $ret
}

function check_computer_model() {
	local ret="UNKNOWN"
	local com_name="$(dmidecode | grep Name)"
	if [ "$ret" == "UNKNOWN" ]; then
		error_log "Not support computer model, this script is just supported ${SUPPORTED_COM_MODEL[*]}"
	fi
	return "$ret"
}
