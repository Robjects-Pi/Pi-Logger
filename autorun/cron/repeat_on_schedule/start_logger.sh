#!/bin/bash

LOGGER_SCRIPT="/home/pi/raspberry_pi_logger/run_log.sh"
LOG_FILE="/home/pi/raspberry_pi_logger/cron_logger.log"

if [ ! -f "$LOGGER_SCRIPT" ]; then
    echo "Error: $LOGGER_SCRIPT not found." >> $LOG_FILE
    exit 1
fi

# Check if the process is already running
if pgrep -f "$LOGGER_SCRIPT" > /dev/null; then
    echo "Logger is already running." >> $LOG_FILE
    exit 0
fi

# Start the logger
nohup "$LOGGER_SCRIPT" >> $LOG_FILE 2>&1 &

echo "Logger started at $(date)" >> $LOG_FILE