# filesync

This program uses rsync to sync data between two folders. Primarily this is used to sync from a local directory to an encrypted cloud directory mounted locally. Key features are a lock file and a messaging system to terminal.

Ideally this is run as a cronjob.

General usage requires a file named "unlock" to be created in the target directory. The program takes to CLI arguements (source and destination: please include trailing slash) and copies files from one location to the other. It does use the "--delete" parameter in rsync to remove files on the remote.

The program will fail with a pop up message if rsync or the unlock file are missing. This program depends on rsync (syncing) and zenity (pop message).

## Credits
Ruwan Samaranayake
## License
Refer to license file in repository
