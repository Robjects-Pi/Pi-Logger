#!/bin/bash

LOGGER_SCRIPT="/home/pi/raspberry_pi_logger/run_log.sh"
LOG_FILE="/home/pi/raspberry_pi_logger/cron_logger.log"

# Kill the process
pkill -f "$LOGGER_SCRIPT"

echo "Logger stopped at $(date)" >> $LOG_FILE