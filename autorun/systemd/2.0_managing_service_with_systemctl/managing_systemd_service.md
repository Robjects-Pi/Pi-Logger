

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Scripts for Autorun at Reboot](#scripts-for-autorun-at-reboot)
  - [`start_and_enable_run_at_reboot.sh`](#start_and-enable-run-at-rebootsh)
  - [`stop_and_disable_run_at_reboot.sh`](#stop-and-disable-run-at-rebootsh)
  - [`check_systemd_status.sh`](#check-systemd-statussh)
- [How to Use These Scripts](#how-to-use-these-scripts)
- [Important Notes](#important-notes)
- [Extra Notes](#extra-notes)
- [Conclusion](#conclusion)
- [Resources](#resources)


## Overview

Systemd is a system and service manager for Linux operating systems that provides a more advanced alternative to traditional init systems like SysVinit. It allows users to manage services, daemons, and other system components, including autorun tasks at system boot.

By creating a systemd service for the Raspberry Pi diagnostics logger, we can ensure that the logger starts automatically at system boot and runs continuously in the background. This approach provides a more robust and integrated solution compared to using cron jobs for autorun tasks.

## Prerequisites

Before setting up the systemd service for the Raspberry Pi diagnostics logger, ensure you have the following:

- A Raspberry Pi running a compatible Linux distribution (e.g., Raspbian, Raspberry Pi OS).
- The Raspberry Pi diagnostics logger script (`logger.py`) installed on the system.



## Scripts for Autorun at Reboot

This section provides three script files to handle the autorun of the Raspberry Pi diagnostics logger at reboot using systemd:

1. `start_and_enable_run_at_reboot.sh`: Enables and starts the systemd service.
2. `stop_and_disable_run_at_reboot.sh`: Stops and disables the systemd service.
3. `check_systemd_status.sh`: Checks the status of the systemd service and any running cron jobs.

### `start_and_enable_run_at_reboot.sh`

This script enables and starts the systemd service, ensuring the diagnostics logger runs at reboot. It also checks for any running cron jobs and prints a warning message if found.

```bash
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
```

### `stop_and_disable_run_at_reboot.sh`

This script stops and disables the systemd service, preventing the diagnostics logger from running at reboot. It also checks for any running cron jobs and prints a warning message if found.

```bash
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
```

### `check_systemd_status.sh`

This script checks the status of the systemd service and any running cron jobs related to the diagnostics logger.

```bash
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
```

### How to Use These Scripts

1. Save each script with its respective name in your Raspberry Pi.

2. Make the scripts executable:
   ```bash
   chmod +x start_and_enable_run_at_reboot.sh
   chmod +x stop_and_disable_run_at_reboot.sh
   chmod +x check_systemd_status.sh
   ```

3. Run the scripts as needed:
   - To start and enable: `./start_and_enable_run_at_reboot.sh`
   - To stop and disable: `./stop_and_disable_run_at_reboot.sh`
   - To check status: `./check_systemd_status.sh`

### Important Notes

- These scripts assume that the systemd service file is named `pi-logger.service`. If you've used a different name, update the `SERVICE_NAME` variable in each script.
- The scripts check for existing cron jobs that might be running `run_log.sh`. They provide warnings but do not automatically remove cron jobs to prevent unintended data loss.
- You need sudo privileges to manage systemd services.
- Always ensure that you're not running both the cron job and the systemd service simultaneously to avoid duplicate logging or resource conflicts.

These scripts provide a comprehensive way to manage your Raspberry Pi Logger service, including starting, stopping, and checking its status, while also being mindful of potential conflicts with existing cron jobs.

These scripts ensure that the autorun of the diagnostics logger at reboot using systemd is properly configured and managed. They also provide checks for any conflicting cron jobs to avoid issues with the logger's execution.

### Extra Notes

I have provided the scripts for enabling, disabling, and checking the status of the systemd service. You can modify these scripts as needed to suit your specific requirements or integrate them into a larger automation workflow. I recommend testing these scripts in a safe environment before deploying them to production systems as some commands may require elevated privileges.

For more details on setting up and managing systemd services, refer to the official documentation: [Systemd Documentation](https://www.freedesktop.org/wiki/Software/systemd/).
