#!/bin/bash

# This script sets up a cron job to run the logger.py script every 5 seconds
# It also checks if a systemd service is running before proceeding

# Name of the systemd service to check (change this if your service has a different name)
SERVICE_NAME="logger_service"

# Check if the systemd service is running
if systemctl is-active --quiet $SERVICE_NAME; then
    echo "The $SERVICE_NAME is currently running."
    echo "To stop the service, run: sudo systemctl stop $SERVICE_NAME"
    echo "Then, run this script again."
    exit 1
fi

# Path to the run_log.sh script
RUN_LOG_SCRIPT="/home/pi/raspberry_pi_logger/run_log.sh"

# Check if the run_log.sh script exists
if [ ! -f "$RUN_LOG_SCRIPT" ]; then
    echo "Error: $RUN_LOG_SCRIPT not found."
    exit 1
fi

# Remove any existing cron job for this script
(crontab -l 2>/dev/null | grep -v "$RUN_LOG_SCRIPT") | crontab -

# Add new cron job to run every 5 seconds
(crontab -l 2>/dev/null; echo "* * * * * $RUN_LOG_SCRIPT") | crontab -
(crontab -l 2>/dev/null; echo "* * * * * (sleep 5; $RUN_LOG_SCRIPT)") | crontab -
(crontab -l 2>/dev/null; echo "* * * * * (sleep 10; $RUN_LOG_SCRIPT)") | crontab -
(crontab -l 2>/dev/null; echo "* * * * * (sleep 15; $RUN_LOG_SCRIPT)") | crontab -
(crontab -l 2>/dev/null; echo "* * * * * (sleep 20; $RUN_LOG_SCRIPT)") | crontab -
(crontab -l 2>/dev/null; echo "* * * * * (sleep 25; $RUN_LOG_SCRIPT)") | crontab -
(crontab -l 2>/dev/null; echo "* * * * * (sleep 30; $RUN_LOG_SCRIPT)") | crontab -
(crontab -l 2>/dev/null; echo "* * * * * (sleep 35; $RUN_LOG_SCRIPT)") | crontab -
(crontab -l 2>/dev/null; echo "* * * * * (sleep 40; $RUN_LOG_SCRIPT)") | crontab -
(crontab -l 2>/dev/null; echo "* * * * * (sleep 45; $RUN_LOG_SCRIPT)") | crontab -
(crontab -l 2>/dev/null; echo "* * * * * (sleep 50; $RUN_LOG_SCRIPT)") | crontab -
(crontab -l 2>/dev/null; echo "* * * * * (sleep 55; $RUN_LOG_SCRIPT)") | crontab -

echo "Cron job has been set up to run $RUN_LOG_SCRIPT every 5 seconds."

# Instructions for changing the interval
echo ""
echo "To change the interval:"
echo "1. Open this script (autorun_cron.sh) in a text editor."
echo "2. Modify the cron job lines. The current setup runs every 5 seconds."
echo "3. For different intervals, adjust the 'sleep' values and the number of lines."
echo "   - For 10-second intervals, use sleep values: 0, 10, 20, 30, 40, 50"
echo "   - For 1-minute intervals, use a single line: * * * * * $RUN_LOG_SCRIPT"
echo "   - For 5-minute intervals, use: */5 * * * * $RUN_LOG_SCRIPT"
echo "4. Save the file and run this script again to update the cron job."