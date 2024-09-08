#!/bin/bash

# start_and_enable_run_at_reboot.sh
# This script starts and enables the Raspberry Pi Logger systemd service to run at reboot

SERVICE_NAME="pi-logger"

# Check for existing cron job
if crontab -l | grep -q 'run_log.sh'; then
    echo "WARNING: You are currently running a cron job with this user that executes run_log.sh."
    echo "Please ensure the cron job is not running before enabling the systemd service."
    echo "You can remove the cron job by editing your crontab with 'crontab -e'."
    exit 1
fi

# Check if the service exists
if [ ! -f "/etc/systemd/system/${SERVICE_NAME}.service" ]; then
    echo "Error: ${SERVICE_NAME}.service does not exist. Please run run_systemd_service.sh first."
    exit 1
fi

# Enable and start the service
sudo systemctl enable ${SERVICE_NAME}.service
sudo systemctl start ${SERVICE_NAME}.service

echo "${SERVICE_NAME} service has been enabled and started."
echo "It will now run automatically at system boot."