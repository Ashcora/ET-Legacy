#!/bin/bash

# Installation path
install_path='/usr/local/games/enemy-territory-legacy/etlegacy-x86_64'

# Function to send an email using mail command
send_email() {
    local subject="$1"
    local body="$2"
    echo "$body" | mail -s "$subject" YOURMAIL@HERE.ME
}

# Downloading the latest ETLegacy Binaries
curl -L https://www.etlegacy.com/download/file/537 -o etlegacy.tar.gz

# Checking if the download was successful
if [ $? -ne 0 ]; then
    send_email "ETLegacy Update Failed" "The download of ETLegacy binaries failed. Please check the logs for details."
    exit 1
fi

# Extracting the binaries
tar xzf etlegacy.tar.gz -C "$install_path" --strip-components=1

# Setting permissions
chmod +x "$install_path"/*

# Cleaning up
rm etlegacy.tar.gz

echo "ETLegacy has been updated!"

# Send the success email
send_email "ETLegacy has been updated" "The ETLegacy update was successful. Check the logs for details."

exit 0
