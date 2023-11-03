#!/bin/bash

# to do
# program description
# check for rsync
# check Crypto folder is accessible
# check trailing slashes

# The "unlock" in the rsync command is a file on the farend that is used for write protection. It is to guard against 
# this script writing into a directory it should not. Use case is a cronjob that periodically writes into a directory,
# but you want to suspend the write on the far end if you cant stop the cronjob at the source.

# Check for the "unlock" file

rsync --help > /dev/null 2>&1

if [ $? -eq 127 ];
   then
       echo "The rsync program is required to use this script."
       exit 0
fi

zenity --help > /dev/null 2>&1

if [ $? -eq 127 ];
   then
       echo "The zenity program is required to use this script."
       exit 0
fi


ls "$2unlock" > /dev/null 2>&1

if [ $? -eq 2 ];
   then
       zenity --warning --text="unlock file not detected at far end. Folder may need encryption key or unlock file has been explictly removed to prevent writes."
       exit 0
fi

date >> log.txt
rsync -vha --copy-links --delete --exclude unlock  "$1" "$2" >> log.txt

if [ $? -eq 0 ];
   then
       echo "Sync Completed Successfully"
   else
       echo "Sync Failed"
fi

exit 0

