To log the executions of a `logger.py` script using cron jobs after a system reboot, you can follow these steps. This setup will ensure that each execution of the logger script is recorded in a log file. Here's how to achieve this:

### Step-by-Step Guide

1. **Create a Wrapper Script**

   Create a script called `run_logger.sh` that will handle the execution of `logger.py` and log the start and end times. Here's an example of what the script should look like:

   ```bash
   #!/bin/bash

   # Define the path for the logger.py script
   LOGGER_SCRIPT="/home/pi/Pi-Logger/raspberry_pi_logger/logger.py"

   # Define the log file path
   LOG_FILE="/var/log/logger_execution.log"

   # Create the log file if it doesn’t exist
   if [ ! -f "$LOG_FILE" ]; then
       touch "$LOG_FILE"
   fi

   # Check if logger.py exists
   if [ ! -f "$LOGGER_SCRIPT" ]; then
       echo "Error: $LOGGER_SCRIPT not found." >> "$LOG_FILE"
       exit 1
   fi

   # Log the start time
   echo "Logger started at $(date)" >> "$LOG_FILE"

   # Execute the logger script
   python3 "$LOGGER_SCRIPT"

   # Log the end time
   echo "Logger ended at $(date)" >> "$LOG_FILE"
   ```

   Make sure to make this script executable:

   ```bash
   chmod +x run_logger.sh
   ```

2. **Set Up the Cron Job**

   Edit the crontab to add a job that runs this script at reboot. You can do this by editing the crontab with the following command:

   ```bash
   crontab -e
   ```

   Add the following line to the crontab to run the script at reboot:

   ```bash
   @reboot /home/pi/Pi-Logger/raspberry_pi_logger/run_logger.sh
   ```

   This entry ensures that the `run_logger.sh` script is executed every time the system reboots.

3. **Verify the Setup**

   - Ensure the paths in `run_logger.sh` are correct and that the `logger.py` script is located at `/home/pi/Pi-Logger/raspberry_pi_logger/logger.py`.
   - Check the log file `/var/log/logger_execution.log` after a reboot to verify that the start and end times are being logged correctly.

### Additional Notes

- **Log File Permissions**: Ensure that the user running the cron job (typically the user who owns the crontab) has write permissions for the log file. You can set the appropriate permissions with:

  ```bash
  sudo chown pi:pi /var/log/logger_execution.log
  ```

- **Error Handling**: The script logs an error message if `logger.py` is not found. This helps in troubleshooting if the script fails to run.

- **Log Rotation**: Consider setting up log rotation for `/var/log/logger_execution.log` to prevent it from growing too large over time.

This setup provides a reliable way to log the execution of your `logger.py` script every time the system reboots, helping you track its activity for monitoring and debugging purposes.