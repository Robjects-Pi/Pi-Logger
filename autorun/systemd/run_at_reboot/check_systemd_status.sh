Certainly! I'll create three script files as requested, each with the functionality to check for existing cron jobs and provide appropriate warnings. Here are the scripts:

1. `start_and_enable_run_at_reboot.sh`
2. `stop_and_disable_run_at_reboot.sh`
3. `check_systemd_status.sh`

Let's go through each script:

### 1. start_and_enable_run_at_reboot.sh

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

### 2. stop_and_disable_run_at_reboot.sh

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

### 3. check_systemd_status.sh

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