## Autorun Cron Script for Raspberry Pi Logger

This section provides a script called `autorun_cron.sh` that sets up a cron job to automatically run the `run_log.sh` script every 5 seconds. The `run_log.sh` script executes the `logger.py` script, which logs system diagnostics.

### Scripts Overview

1. **run_log.sh**: Executes the Python logger script.
2. **autorun_cron.sh**: Configures the cron job to run `run_log.sh` every 5 seconds.

### Script: `run_log.sh`

This script executes the `logger.py` script located in the specified directory.

```bash
#!/bin/bash

# This script executes the Python logger script for Raspberry Pi diagnostics

# Change directory to where the logger.py script is located
cd ~/raspberry_pi_logger

# Execute the logger.py script
python3 logger.py
```

### Script: `autorun_cron.sh`

This script sets up a cron job to run the `run_log.sh` script every 5 seconds.

```bash
#!/bin/bash

# This script sets up a cron job to run the logger script every 5 seconds

# Change directory to where the run_log.sh script is located
cd ~/raspberry_pi_logger

# Write out current crontab
crontab -l > mycron

# Echo new cron into cron file
echo "*/5 * * * * /bin/bash /home/pi/raspberry_pi_logger/run_log.sh" >> mycron

# Install new cron file
crontab mycron

# Remove the temporary cron file
rm mycron

# Inform the user that the cron job has been set
echo "Cron job set to run every 5 seconds."
```

### Setting Up the Scripts


























### Script: `autorun_cron.sh`

This script sets up a cron job to run `run_log.sh` every 5 seconds.

```bash
#!/bin/bash

# This script sets up a cron job to run 'run_log.sh' every 5 seconds.

# Remove any existing cron jobs for this script to avoid duplicates
# The crontab -l command lists existing cron jobs, and grep removes those for 'run_log.sh'
crontab -l | grep -v 'run_log.sh' | crontab -

# Define the cron job command to execute run_log.sh every 5 seconds
# This setup creates multiple entries to handle one execution every 5 seconds.
# Ensure the path to run_log.sh is correct.
cron_job="* * * * * /bin/bash /home/pi/raspberry_pi_logger/run_log.sh\n* * * * * sleep 5; /bin/bash /home/pi/raspberry_pi_logger/run_log.sh\n* * * * * sleep 10; /bin/bash /home/pi/raspberry_pi_logger/run_log.sh\n* * * * * sleep 15; /bin/bash /home/pi/raspberry_pi_logger/run_log.sh\n* * * * * sleep 20; /bin/bash /home/pi/raspberry_pi_logger/run_log.sh\n* * * * * sleep 25; /bin/bash /home/pi/raspberry_pi_logger/run_log.sh\n* * * * * sleep 30; /bin/bash /home/pi/raspberry_pi_logger/run_log.sh\n* * * * * sleep 35; /bin/bash /home/pi/raspberry_pi_logger/run_log.sh\n* * * * * sleep 40; /bin/bash /home/pi/raspberry_pi_logger/run_log.sh\n* * * * * sleep 45; /bin/bash /home/pi/raspberry_pi_logger/run_log.sh\n* * * * * sleep 50; /bin/bash /home/pi/raspberry_pi_logger/run_log.sh\n* * * * * sleep 55; /bin/bash /home/pi/raspberry_pi_logger/run_log.sh"

# Add the cron job to the user's crontab
# Using (echo "$cron_job") to update with the new settings.
( echo "$cron_job" ) | crontab -

# Inform the user that the cron job has been set
echo "Cron job set to run run_log.sh every 5 seconds."
```

### Setting Up the Scripts

1. **Create the `run_log.sh` Script**: 
   - Open a terminal and create the script:
     ```bash
     nano /home/pi/raspberry_pi_logger/run_log.sh
     ```
   - Copy and paste the contents of the `run_log.sh` script above, then save and exit.

2. **Create the `autorun_cron.sh` Script**: 
   - In the terminal, create the script:
     ```bash
     nano /home/pi/raspberry_pi_logger/autorun_cron.sh
     ```
   - Copy and paste the contents of the `autorun_cron.sh` script above, then save and exit.

3. **Make Both Scripts Executable**:
   - Run the following commands to make the scripts executable:
     ```bash
     chmod +x /home/pi/raspberry_pi_logger/run_log.sh
     chmod +x /home/pi/raspberry_pi_logger/autorun_cron.sh
     ```

4. **Run the Autorun Script**:
   - Execute the autorun script to set up the cron job:
     ```bash
     /home/pi/raspberry_pi_logger/autorun_cron.sh
     ```

### Configuring the Logging Frequency

- To change the frequency of logging, you can modify the `cron_job` variable in the `autorun_cron.sh` script. For example:
  - To run every minute, you would replace the existing entries with:
    ```bash
    cron_job="* * * * * /bin/bash /home/pi/raspberry_pi_logger/run_log.sh"
    ```

This setup will ensure that your Raspberry Pi logger runs automatically at the desired intervals, collecting valuable diagnostic data continuously.