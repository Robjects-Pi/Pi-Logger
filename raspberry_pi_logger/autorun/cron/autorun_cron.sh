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