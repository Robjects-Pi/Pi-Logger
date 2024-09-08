# Running our Logger Script at Specific Times Using Cron Jobs


In this guide, we'll create two scripts (`start_logger.sh` and `stop_logger.sh`) to control the logging process and set up cron jobs to execute these scripts at desired times.  This approach provides more control over when the logger runs and allows for scheduled start and stop times. For example, you can start the logger at 8 AM and stop it at 8 PM every day. This method is useful when you want to log data only during certain hours or at specific intervals due to power consumption, data storage, or data collection requirements.This approach provides a flexible way to manage the logging process based on your scheduling needs.

## Instructions

Follow these steps to set up the start and stop scripts and configure cron jobs to control the logging process:



### 1. Create start_logger.sh

Create a new file called `start_logger.sh` in the same directory as `run_log.sh`:

```bash
#!/bin/bash

LOGGER_SCRIPT="/home/pi/raspberry_pi_logger/run_log.sh"
LOG_FILE="/home/pi/raspberry_pi_logger/cron_logger.log"

if [ ! -f "$LOGGER_SCRIPT" ]; then
    echo "Error: $LOGGER_SCRIPT not found." >> $LOG_FILE
    exit 1
fi

# Check if the process is already running
if pgrep -f "$LOGGER_SCRIPT" > /dev/null; then
    echo "Logger is already running." >> $LOG_FILE
    exit 0
fi

# Start the logger
nohup "$LOGGER_SCRIPT" >> $LOG_FILE 2>&1 &

echo "Logger started at $(date)" >> $LOG_FILE
```

### 2. Create stop_logger.sh

Create another file called `stop_logger.sh`:

```bash
#!/bin/bash

LOGGER_SCRIPT="/home/pi/raspberry_pi_logger/run_log.sh"
LOG_FILE="/home/pi/raspberry_pi_logger/cron_logger.log"

# Kill the process
pkill -f "$LOGGER_SCRIPT"

echo "Logger stopped at $(date)" >> $LOG_FILE
```

### 3. Make the scripts executable

```bash
chmod +x start_logger.sh stop_logger.sh
```

### 4. Set up cron jobs


To set up cron jobs to start and stop the logger at specific times, we'll add entries to the crontab file. You can choose from the following formats suggested above and apply them to the start and stop scripts:
 
Find the crontab file for the current user:

```bash
crontab -e
```

Add the following lines to the crontab file based on your desired schedule. Here are a few examples to get you started:


- Option 1: Add lines to start and stop the logger at specific times. For example, to start at 8 AM and stop at 8 PM every day:

```bash
# Start logger at 8 AM
# The format is as follows: 
# minute hour day month day_of_week command
# asterisks (*) represent any value

0 8 * * * /home/pi/raspberry_pi_logger/start_logger.sh
0 20 * * * /home/pi/raspberry_pi_logger/stop_logger.sh
```

- Option 2: Add a line to start the logger every 5  minutes:

```bash
# Start logger every 5 minutes
*/5 * * * * /home/pi/raspberry_pi_logger/start_logger.sh
```

- Option 3: Add a line to stop the logger every 10 minutes:

```bash
# Stop logger every 10 minutes
*/10 * * * * /home/pi/raspberry_pi_logger/stop_logger.sh
```

Save and exit the crontab editor.



## Troubleshooting

- If the logger doesn't run, check the permissions of the scripts and the Python file.
- Verify that the paths in the scripts match your actual file locations.
- Check system logs (`/var/log/syslog`) for any cron-related errors.
- Ensure that the cron jobs are correctly set up and the scripts are executable.

### Notes

- The `start_logger.sh` script checks if the logger is already running before starting a new instance, preventing duplicate processes.
- The `stop_logger.sh` script uses `pkill` to terminate all instances of the logger script.
- Both scripts log their actions to `logger.log` for easy troubleshooting.
- Adjust the cron job times in step 4 to fit your specific scheduling needs.
- Ensure that the paths in the scripts match your actual file locations.
- You can customize the scripts further based on your requirements.

## Summary

By creating start and stop scripts and setting up cron jobs, you can control the logging process based on your desired schedule. This approach provides flexibility and automation for managing the logger, allowing you to log data at specific times or intervals. You can easily modify the cron job entries to suit your needs and adjust the logging process as required.

Next, we'll explore how to run the logger script continuously at system boot using a single cron job for efficient and continuous operation. For detailed instructions on setting up cron jobs to run at reboot, please refer to the [reboot instructions](./running_at_reboot/).