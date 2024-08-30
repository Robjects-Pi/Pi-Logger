#!/bin/bash

# start_and_enable_run_at_reboot.sh
# This script adds a cron job to run the run_log.sh script at reboot

CRON_JOB="@reboot /home/pi/raspberry_pi_logger/run_log.sh"

# Check for existing cron job
if crontab -l | grep -q 'run_log.sh'; then
    echo "A cron job for run_log.sh already exists."
else
    # Add the cron job
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Cron job added to run run_log.sh at reboot."
fi