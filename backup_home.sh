#!/bin/bash
##########################################################################################
# DONT TOUCH FOLLOWING SCRIPTS
##########################################################################################
source common.sh

BACKUP_DIR_LIST=(
   "/home/${INSTALL_USER}/Documents"
   "/home/${INSTALL_USER}/Pictures"
   "/home/${INSTALL_USER}/Music"
   "/home/${INSTALL_USER}/Projects"
   "/home/${INSTALL_USER}/Workspace"
   "/home/${INSTALL_USER}/.ssh"
   "/home/${INSTALL_USER}/Backup"
)
BACKUP_DST_PATH="/media/sungjun.kim/SSD-T7-2T"
BACKUP_TAR_PATH="/home/${INSTALL_USER}"
BACKUP_TAR_FILENAME="home_backup.tar.gz"


#Check package
if ! which pv >> /dev/null; then
   error_log "Error! cannot found pv, sudo apt install pv"
   exit 64
fi

#Check src, dst are vaild
for tgt in "${BACKUP_DIR_LIST[@]}"; do
   if [ ! -d $tgt ]; then
      error_log "$tgt is not exist..."
      exit 1
   fi
   progress_log "Check path" "$tgt check done.."
done

# Make tarball
progress_log "Make Tarball" "Compress files to $BACKUP_TAR_FILENAME..."
tar -cf - "${BACKUP_DIR_LIST[@]}" | pv -s $(du -cb "${BACKUP_DIR_LIST[@]}" | tail -1 | awk '{print $1}') | gzip > $BACKUP_TAR_PATH/$BACKUP_TAR_FILENAME

#Copy to DST path
progress_log "Copy Backup files" "Copy $BACKUP_TAR_PATH/$BACKUP_TAR_FILENAME to $BACKUP_DST_PATH..."
pv $BACKUP_TAR_PATH/$BACKUP_TAR_FILENAME > $BACKUP_DST_PATH/$BACKUP_TAR_FILENAME


success_log "Finish backup files!"