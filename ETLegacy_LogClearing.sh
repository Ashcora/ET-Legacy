#!/bin/bash

# Set the maximum number of lines or file size
max_lines=10000000
max_size=5M

# Function to send an email using ssmtp
send_email() {
    local subject="$1"
    local body="$2"
    echo "$body" | mail -s "$subject" YOURMAIL@HERE.ME
}

# Function to truncate log files based on maximum size
truncate_log_file() {
    local file="$1"
    local size="$2"
    truncate -s "$size" "$file"
}

# Function to extract last n lines from a log file
extract_last_lines() {
    local file="$1"
    local lines="$2"
    tail -n "$lines" "$file" >"${file}.tmp"
    mv "${file}.tmp" "$file"
}

# Loop through all log files in the directory
for file in /root/.etlegacy/*.log; do
    # Check if the file is larger than the max size
    if [ $(stat -c %s "$file") -gt $(numfmt --from=iec "$max_size") ]; then
        # If it is, truncate it to the max size
        truncate_log_file "$file" "$max_size"
    fi

    # Check if the file has more lines than the max lines
    if [ $(wc -l <"$file") -gt "$max_lines" ]; then
        # If it does, extract the last max_lines and save it back to the file
        extract_last_lines "$file" "$max_lines"
    fi
done

# Send email notification
if [ $? -eq 0 ]; then
    send_email "ETLegacy Log clearing completed successfully" "The log clearing process was successful. Check the logs for details."
else
    send_email "Script failed" "The log clearing process encountered an error. Please check the logs for details."
    exit 1
fi

# Exit
exit 0
