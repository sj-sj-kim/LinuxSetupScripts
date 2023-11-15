#!/bin/bash

##########################################################################################
#Setup git configs
##########################################################################################
source common.sh

if [ -f backup/$DEFAULT_GITCONFIG ]; then
	cp backup/$DEFAULT_GITCONFIG ~/.gitconfig
	success_log "copy git config file done..."
fi

#apply fancy-git config

git config --global user.name "$GIT_NAME"
git config --global user.email $GIT_EMAIL
