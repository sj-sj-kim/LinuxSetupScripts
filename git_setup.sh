#!/bin/bash

##########################################################################################
#Setup git configs
##########################################################################################
source common.sh

if [ -f backup/$DEFAULT_GITCONFIG ]; then
	cp backup/$DEFAULT_GITCONFIG ~/.gitconfig
	success_log "copy git config file done..."
fi
git config --global user.name "$GIT_NAME"
git config --global user.email $GIT_EMAIL	

echo "parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1=\"\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ \"" | tee -a ~/.bashrc
