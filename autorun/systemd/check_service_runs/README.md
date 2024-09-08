

1. First, let's modify the `pi-logger.service` file to log its activity.
2. Then, we'll create a new script to easily view these logs.

### 1. Modifying the pi-logger.service file

Edit the `pi-logger.service` file (usually located at `/etc/systemd/system/pi-logger.service`) to include logging commands. Here's how the modified service file should look:

```ini
[Unit]
Description=Raspberry Pi Logger Service
After=network.target

[Service]
ExecStartPre=/bin/sh -c 'echo "Pi Logger started at $(date)" >> /var/log/pi-logger-runs.log'
ExecStart=/bin/bash -c "while true; do python3 /home/pi/Pi-Logger/raspberry_pi_logger/logger.py; sleep 5; done"
ExecStopPost=/bin/sh -c 'echo "Pi Logger stopped at $(date)" >> /var/log/pi-logger-runs.log'
WorkingDirectory=/home/pi/Pi-Logger/raspberry_pi_logger
User=pi
Restart=always

[Install]
WantedBy=multi-user.target
```

After modifying this file, you need to reload the systemd daemon and restart the service:

```bash
sudo systemctl daemon-reload
sudo systemctl restart pi-logger.service
```

### 2. Creating a script to view the logs

Now, let's create a script called `view_pi_logger_runs.sh` to easily view these logs:

```bash
#!/bin/bash

# view_pi_logger_runs.sh
# This script displays the run history of the pi-logger service

LOG_FILE="/var/log/pi-logger-runs.log"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file not found. The pi-logger service may not have run yet."
    exit 1
fi

# Display the contents of the log file
echo "Pi Logger Run History:"
echo "----------------------"
cat "$LOG_FILE"

# Option to clear the log file
read -p "Do you want to clear the log file? (y/n): " choice
case "$choice" in 
  y|Y ) 
    sudo truncate -s 0 "$LOG_FILE"
    echo "Log file cleared."
    ;;
  * ) 
    echo "Log file kept intact."
    ;;
esac
```

Make this script executable:

```bash
chmod +x view_pi_logger_runs.sh
```

### How to Use

1. **Viewing Logs**: Run the `view_pi_logger_runs.sh` script to see when the pi-logger service has started and stopped:

   ```bash
   ./view_pi_logger_runs.sh
   ```

   This will display the contents of the log file, showing the start and stop times of the pi-logger service.

2. **Clearing Logs**: The script also gives you the option to clear the log file if it gets too large.

### Additional Notes

1. **Log Rotation**: For long-term use, consider setting up log rotation for the `/var/log/pi-logger-runs.log` file to prevent it from growing too large. You can do this by creating a file `/etc/logrotate.d/pi-logger` with the following content:

   ```
   /var/log/pi-logger-runs.log {
       weekly
       rotate 4
       compress
       missingok
       notifempty
   }
   ```

   This will rotate the log file weekly, keep 4 weeks of logs, and compress old logs.

2. **Permissions**: Ensure that the user running the pi-logger service (usually 'pi') has write permissions for the log file:

   ```bash
   sudo touch /var/log/pi-logger-runs.log
   sudo chown pi:pi /var/log/pi-logger-runs.log
   ```

3. **Integration**: You might want to update your `run_systemd_service.sh` script to include these modifications to the service file and create the initial log file.

This setup will give you a clear record of when the pi-logger service starts and stops, which can be useful for monitoring and troubleshooting purposes.