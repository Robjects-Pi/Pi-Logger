
# Running Pi-Logger at Specific Times Using Cron Jobs

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [File Structure](#file-structure)
4. [Setting Up Cron Jobs](#setting-up-cron-jobs)
   - [Scripts Overview](#scripts-overview)
   - [Cron Job Configuration](#cron-job-configuration)
5. [Troubleshooting](#troubleshooting)
6. [Summary and Next Steps](#summary-and-next-steps)

## Introduction

Cron jobs are a powerful tool for scheduling tasks on Unix-like systems. This guide demonstrates how to use cron jobs to automate the execution of the Pi-Logger script at specific times or intervals. By creating start and stop scripts and configuring cron jobs, you can control when the logger runs, allowing for scheduled start and stop times.

This approach is particularly useful when you need to:
- Log data only during certain hours
- Manage power consumption
- Control data storage usage
- Meet specific data collection requirements

For a deeper understanding of cron jobs, refer to the [Cron Jobs Overview](./cron_jobs_overview.md) document.

## Prerequisites

To implement this cron job setup for the Pi-Logger project, ensure you have:

1. A Raspberry Pi or similar Unix-like system
2. Basic knowledge of command-line operations
3. Terminal access or SSH connection to your Raspberry Pi
4. Pi-Logger project installed on your system
5. Permissions to create and edit files in the project directory
6. Familiarity with cron job syntax and usage

## File Structure

The cron subdirectory should have the following structure:

```
cron/
├── cron_jobs_overview.md
├── README.md
├── start_logger.sh
├── stop_logger.sh
├── run_log.sh
└── repeat_on_boot/
    ├── reboot_instructions.md
    └── run_logger_on_boot.sh
```

## Setting Up Cron Jobs

### Scripts Overview

#### start_logger.sh

This script starts the logger if it's not already running:

```bash
#!/bin/bash
LOGGER_SCRIPT="/home/pi/raspberry_pi_logger/run_log.sh"
LOG_FILE="/home/pi/raspberry_pi_logger/cron_logger.log"

if [ ! -f "$LOGGER_SCRIPT" ]; then
    echo "Error: $LOGGER_SCRIPT not found." >> $LOG_FILE
    exit 1
fi

if pgrep -f "$LOGGER_SCRIPT" > /dev/null; then
    echo "Logger is already running." >> $LOG_FILE
    exit 0
fi

nohup "$LOGGER_SCRIPT" >> $LOG_FILE 2>&1 &
echo "Logger started at $(date)" >> $LOG_FILE
```

#### stop_logger.sh

This script stops the logger:

```bash
#!/bin/bash
LOGGER_SCRIPT="/home/pi/raspberry_pi_logger/run_log.sh"
LOG_FILE="/home/pi/raspberry_pi_logger/cron_logger.log"

pkill -f "$LOGGER_SCRIPT"
echo "Logger stopped at $(date)" >> $LOG_FILE
```

#### run_log.sh

This is the main logging script from the Pi-Logger project. Ensure it's properly configured and located in the correct directory.

### Cron Job Configuration

1. Make the scripts executable:
   ```bash
   chmod +x start_logger.sh stop_logger.sh
   ```

2. Edit the crontab file:
   ```bash
   crontab -e
   ```

3. Add cron job entries. Choose from these options:

   - Start at 8 AM and stop at 8 PM daily:
     ```
     0 8 * * * /home/pi/raspberry_pi_logger/start_logger.sh
     0 20 * * * /home/pi/raspberry_pi_logger/stop_logger.sh
     ```

   - Start logger every 5 minutes:
     ```
     */5 * * * * /home/pi/raspberry_pi_logger/start_logger.sh
     ```

   - Stop logger every 10 minutes:
     ```
     */10 * * * * /home/pi/raspberry_pi_logger/stop_logger.sh
     ```

4. Save and exit the crontab editor.

## Troubleshooting

If you encounter issues:

- Check script permissions and file locations
- Verify cron job configurations
- Review system logs (`/var/log/syslog`) for cron-related errors
- Examine the `cron_logger.log` file for script-specific logs

## Summary and Next Steps

This setup allows you to control the Pi-Logger process based on your desired schedule, providing flexibility and automation. You can easily modify the cron job entries to suit your specific needs.

For instructions on running the logger continuously from system boot, refer to the [reboot instructions](./repeat_on_boot/reboot_instructions.md) in the `repeat_on_boot` directory.

By implementing these cron jobs, you can efficiently manage your Pi-Logger, ensuring it operates according to your specific time and resource requirements.
