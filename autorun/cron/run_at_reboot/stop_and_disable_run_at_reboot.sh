#!/bin/bash

# stop_and_disable_run_at_reboot.sh
# This script removes the cron job for run_log.sh

# Check for existing cron job
if crontab -l | grep -q 'run_log.sh'; then
    # Remove the cron job
    crontab -l | grep -v 'run_log.sh' | crontab -
    echo "Cron job for run_log.sh has been removed."
else
    echo "No cron job found for run_log.sh."
fi