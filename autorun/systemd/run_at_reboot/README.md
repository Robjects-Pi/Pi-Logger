## Scripts for Autorun at Reboot

This section provides three script files to handle the autorun of the Raspberry Pi diagnostics logger at reboot using systemd:

1. `start_and_enable_run_at_reboot.sh`: Enables and starts the systemd service.
2. `stop_and_disable_run_at_reboot.sh`: Stops and disables the systemd service.
3. `check_systemd_status.sh`: Checks the status of the systemd service and any running cron jobs.

### `start_and_enable_run_at_reboot.sh`

This script enables and starts the systemd service, ensuring the diagnostics logger runs at reboot. It also checks for any running cron jobs and prints a warning message if found.

```bash
#!/bin/bash

# Check if a cron job is running for run_log.sh
running_cron_jobs=$(crontab -u $USER -l | grep 'run_log.sh')

if [ ! -z "$running_cron_jobs" ]; then
    echo "Warning: You are currently running a cron job with this user, please ensure cron job is not running run_log.sh file before enabling the systemd service."
    exit 1
fi

# Enable the systemd service
sudo systemctl enable create_symlink.service
sudo systemctl start create_symlink.service

echo "Systemd service has been started and enabled at reboot."
```

### `stop_and_disable_run_at_reboot.sh`

This script stops and disables the systemd service, preventing the diagnostics logger from running at reboot. It also checks for any running cron jobs and prints a warning message if found.

```bash
#!/bin/bash

# Check if a cron job is running for run_log.sh
running_cron_jobs=$(crontab -u $USER -l | grep 'run_log.sh')

if [ ! -z "$running_cron_jobs" ]; then
    echo "Warning: You are currently running a cron job with this user, please ensure cron job is not running run_log.sh file before disabling the systemd service."
    exit 1
fi

# Disable and stop the systemd service
sudo systemctl stop create_symlink.service
sudo systemctl disable create_symlink.service

echo "Systemd service has been stopped and disabled from running at reboot."
```

### `check_systemd_status.sh`

This script checks the status of the systemd service and any running cron jobs related to the diagnostics logger.

```bash
#!/bin/bash

# Check the status of the systemd service
status=$(systemctl is-active create_symlink.service)

if [ "$status" == "active" ]; then
    echo "The systemd service 'create_symlink.service' is currently running."
else
    echo "The systemd service 'create_symlink.service' is not running."
fi

# Also check for running cron jobs
running_cron_jobs=$(crontab -u $USER -l | grep 'run_log.sh')
if [ ! -z "$running_cron_jobs" ]; then
    echo "Warning: You are currently running a cron job with this user, please ensure cron job is not running run_log.sh file before proceeding."
fi
```

These scripts ensure that the autorun of the diagnostics logger at reboot using systemd is properly configured and managed. They also provide checks for any conflicting cron jobs to avoid issues with the logger's execution.

### Extra Notes

I have provided the scripts for enabling, disabling, and checking the status of the systemd service. You can modify these scripts as needed to suit your specific requirements or integrate them into a larger automation workflow. I recommend testing these scripts in a safe environment before deploying them to production systems as some commands may require elevated privileges.

For more details on setting up and managing systemd services, refer to the official documentation: [Systemd Documentation](https://www.freedesktop.org/wiki/Software/systemd/).
