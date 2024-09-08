#!/bin/bash

# check_systemd_status.sh
# This script checks the status of the Raspberry Pi Logger systemd service

SERVICE_NAME="pi-logger"

# Check for existing cron job
if crontab -l | grep -q 'run_log.sh'; then
    echo "WARNING: You are currently running a cron job with this user that executes run_log.sh."
    echo "This may interfere with the systemd service if both are running simultaneously."
    echo "Consider disabling the cron job if you're using the systemd service."
fi

# Check if the service exists
if [ ! -f "/etc/systemd/system/${SERVICE_NAME}.service" ]; then
    echo "Error: ${SERVICE_NAME}.service does not exist."
    exit 1
fi

# Check the status of the service
echo "Current status of ${SERVICE_NAME} service:"
sudo systemctl status ${SERVICE_NAME}.service

# Check if the service is enabled
if sudo systemctl is-enabled ${SERVICE_NAME}.service &> /dev/null; then
    echo "The service is enabled and will start at boot."
else
    echo "The service is not enabled and will not start at boot."
fi