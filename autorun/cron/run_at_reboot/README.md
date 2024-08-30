Certainly! Below are the scripts to manage a cron job that ensures `run_log.sh` is executed at reboot and at regular intervals. These scripts will help you start, stop, and check the status of the cron job.

### 1. start_and_enable_run_at_reboot.sh

This script adds a cron job to run `run_log.sh` at reboot.

```bash
#!/bin/bash

# start_and_enable_run_at_reboot.sh
# This script adds a cron job to run the run_log.sh script at reboot

CRON_JOB="@reboot /home/pi/raspberry_pi_logger/run_log.sh"

# Check for existing cron job
if crontab -l | grep -q 'run_log.sh'; then
    echo "A cron job for run_log.sh already exists."
else
    # Add the cron job
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Cron job added to run run_log.sh at reboot."
fi
```

### 2. stop_and_disable_run_at_reboot.sh

This script removes the cron job that runs `run_log.sh` at reboot.

```bash
#!/bin/bash

# stop_and_disable_run_at_reboot.sh
# This script removes the cron job for run_log.sh

# Check for existing cron job
if crontab -l | grep -q 'run_log.sh'; then
    # Remove the cron job
    crontab -l | grep -v 'run_log.sh' | crontab -
    echo "Cron job for run_log.sh has been removed."
else
    echo "No cron job found for run_log.sh."
fi
```

### 3. check_systemd_status.sh

This script checks whether the cron job for `run_log.sh` is set up.

```bash
#!/bin/bash

# check_systemd_status.sh
# This script checks the status of the cron job for run_log.sh

# Check for existing cron job
if crontab -l | grep -q 'run_log.sh'; then
    echo "Cron job for run_log.sh is active."
else
    echo "No cron job found for run_log.sh."
fi
```

### How to Use These Scripts

1. **Save the Scripts**: Save each of these scripts with their respective names in your Raspberry Pi.

2. **Make the Scripts Executable**: Run the following commands to make the scripts executable:

   ```bash
   chmod +x start_and_enable_run_at_reboot.sh
   chmod +x stop_and_disable_run_at_reboot.sh
   chmod +x check_systemd_status.sh
   ```

3. **Run the Scripts**:
   - To add the cron job and enable it to run at reboot, execute:
     ```bash
     ./start_and_enable_run_at_reboot.sh
     ```
   - To disable and remove the cron job, execute:
     ```bash
     ./stop_and_disable_run_at_reboot.sh
     ```
   - To check if the cron job is active, execute:
     ```bash
     ./check_systemd_status.sh
     ```

### Notes

- **Cron Job Timing**: The cron job is set to run `run_log.sh` at reboot. If you want to run it at regular intervals as well, you can modify the `start_and_enable_run_at_reboot.sh` script to include additional cron timing entries.
- **Script Paths**: Ensure that the path to `run_log.sh` in the scripts matches the actual location of your script.
- **User Permissions**: These scripts assume the user running them has permission to modify their own crontab. Adjust user permissions as necessary.