#!/bin/bash



# Check_cron_job_status.sh



# This script checks the status of the cron job for run_log.sh

# Check for existing cron job
if crontab -l | grep -q 'run_log.sh'; then
    echo "Cron job for run_log.sh is active."
else
    echo "No cron job found for run_log.sh."
fi