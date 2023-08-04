#!/bin/bash

# Installation path
install_path='/usr/local/games/enemy-territory-legacy/etlegacy-x86_64'

# Function to send an email using ssmtp (see ssmtp for more details)
send_email() {
    local subject="$1"
    local body="$2"
    echo "Subject: $subject" >/tmp/email.txt
    echo -e "$body" >>/tmp/email.txt
    ssmtp YOURMAIL@HERE.ME </tmp/email.txt
}

# Download the latest ETLegacy Binaries
curl -L https://www.etlegacy.com/download/file/537 -o etlegacy.tar.gz

# Prüfen, ob das Herunterladen erfolgreich war
if [ $? -ne 0 ]; then
    send_email "ETLegacy Update Failed" "The download of ETLegacy binaries failed. Please check the logs for details."
    exit 1
fi

# Extracting the ETLegacy Binaries
tar xzf etlegacy.tar.gz -C "$install_path" --strip-components=1

# Set permissions to installation path
chmod +x "$install_path"/*

# Cleanup
rm etlegacy.tar.gz

echo "ETLegacy has been updated!"

# Send the success email
send_email "ETLegacy has been updated" "The ETLegacy update was successful. Check the logs for details."

exit 0
