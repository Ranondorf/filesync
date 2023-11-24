#!/bin/bash

# to do
# program description
# check for rsync
# check Crypto folder is accessible
# check trailing slashes

# The "unlock" in the rsync command is a file on the farend that is used for write protection. It is to guard against 
# this script writing into a directory it should not. Use case is a cronjob that periodically writes into a directory,
# but you want to suspend the write on the far end if you cant stop the cronjob at the source.

log_file="crypto_sync_log.txt"

echo "---------------------------------------" >> $log_file
echo "$(date)" >> $log_file


# Check for "rsync"

rsync --help > /dev/null 2>&1

if [ $? -eq 127 ];
   then
       echo "rsync is missing, aborting." >> $log_file
       echo "The rsync program is required to use this script."
       exit 0
fi

# Check for "zenity"

zenity --help > /dev/null 2>&1

if [ $? -eq 127 ];
   then
       echo "zenity is missing, aborting." >> $log_file
       echo "The zenity program is required to use this script."
       exit 0
fi

# Check for the "unlock" file on the far end

ls "$2unlock" > /dev/null 2>&1

if [ $? -eq 2 ];
   then
       echo "unlock file not detected at far end. Folder may need encryption key or unlock file has been explictly removed to prevent writes."
       zenity --warning --text="unlock file not detected at far end. Folder may need encryption key or unlock file has been explictly removed to prevent writes."
       exit 0
fi

# Main bit of the code. Exlude is not necessary here as this is currently being called to backup up to the cloud (unlock is on the cloud side), instead of keeping both sides in sync.

rsync -vha --copy-links --delete --exclude unlock  "$1" "$2" >> $log_file

if [ $? -eq 0 ];
   then
       echo "Sync Completed Successfully" >> $log_file
       echo "Program completed successfully, please see logs for details"
       exit 0
   else
       echo "Sync Failed" >> $log_file
       echo "Program failed, please see logs for details"
       zenity --warning --text="Overnight job failed, please see logs"
       exit 1
fi

