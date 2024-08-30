#!/bin/bash

# This script executes the Python logger script for Raspberry Pi diagnostics

# Change directory to where the logger.py script is located

# Example path to the logger.py script (assuming the script is in the raspberry_pi_logger directory)
# cd ../raspberry_pi_logger

# Change the directory to where the logger.py script is located
# Replace the path with the correct path to the logger.py script
# cd /path/to/raspberry_pi_logger # Default path from script location is the current directory (./)



# Command to execute the logger.py script
# Make sure to configure the correct Python path if different from python3
python3 logger.py

# To change the frequency of logging, modify the cron job in autorun_cron.sh
# For example, to run every minute, replace the cron job settings accordingly.