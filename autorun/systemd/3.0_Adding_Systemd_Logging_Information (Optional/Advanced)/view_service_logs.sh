#!/bin/bash

# view_pi_logger_runs.sh
# This script displays the run history of the pi-logger service

LOG_FILE="/var/log/pi-logger-runs.log"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file not found. The pi-logger service may not have run yet."
    exit 1
fi

# Display the contents of the log file
echo "Pi Logger Run History:"
echo "----------------------"
cat "$LOG_FILE"

# Option to clear the log file
read -p "Do you want to clear the log file? (y/n): " choice
case "$choice" in 
  y|Y ) 
    sudo truncate -s 0 "$LOG_FILE"
    echo "Log file cleared."
    ;;
  * ) 
    echo "Log file kept intact."
    ;;
esac