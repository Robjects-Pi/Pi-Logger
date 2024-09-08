#!/bin/bash

# stop_and_disable_run_at_reboot.sh
# This script stops and disables the Raspberry Pi Logger systemd service

SERVICE_NAME="pi-logger"

# Check for existing cron job
if crontab -l | grep -q 'run_log.sh'; then
    echo "WARNING: You are currently running a cron job with this user that executes run_log.sh."
    echo "This script will only stop the systemd service. The cron job will continue to run."
    echo "To stop the cron job, please edit your crontab with 'crontab -e'."
fi

# Check if the service exists
if [ ! -f "/etc/systemd/system/${SERVICE_NAME}.service" ]; then
    echo "Error: ${SERVICE_NAME}.service does not exist."
    exit 1
fi

# Stop and disable the service
sudo systemctl stop ${SERVICE_NAME}.service
sudo systemctl disable ${SERVICE_NAME}.service

echo "${SERVICE_NAME} service has been stopped and disabled."
echo "It will no longer run automatically at system boot."