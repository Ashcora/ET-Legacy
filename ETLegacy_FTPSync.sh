#!/bin/bash

# Define local and remote directories
local_dir="/usr/local/games/enemy-territory-legacy/etlegacy-x86_64/legacy"
remote_dir="legacy"

# Define filter criteria
filter="legacy*.pk3"

# Define SFTP server credentials
sftp_user="USER"
sftp_password="PASSWORD"
sftp_host="HOSTNAME"
sftp_port=22

# Function to send an email using ssmtp
send_email() {
    local subject="$1"
    local body="$2"
    echo "Subject: $subject" >/tmp/email.txt
    echo -e "$body" >>/tmp/email.txt
    ssmtp YOURMAIL@HERE.ME </tmp/email.txt
}

# Function to delete (old) legacy*.pk3 files on the remote FTP server
delete_legacy_files() {
    echo "Deleting legacy*.pk3 files on the remote FTP server..."
    sshpass -p "$sftp_password" sftp -P "$sftp_port" "$sftp_user@$sftp_host" <<EOF
        cd $remote_dir
        rm $filter
        quit
EOF
}

# Delete legacy*.pk3 files on the remote FTP server before synchronization
delete_legacy_files

# Synchronize files using SFTP
if sshpass -p "$sftp_password" sftp -P "$sftp_port" "$sftp_user@$sftp_host" <<EOF; then
    cd $remote_dir
    mput $local_dir/$filter
    quit
EOF
    # Synchronization succeeded
    send_email "FTP Sync has been completed" "The FTP synchronization was successful. Check the logs for details."
else
    # Synchronization failed
    send_email "Script failed" "The FTP synchronization failed. Please check the logs for details."
    exit 1
fi

# Clean up and exit
rm /tmp/email.txt
exit 0
