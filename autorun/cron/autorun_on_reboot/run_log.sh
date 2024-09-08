#!/bin/bash

LOGGER_SCRIPT_DIR="/home/pi/raspberry_pi_logger"
INTERVAL=5  # Interval in seconds

if [ ! -f "$LOGGER_SCRIPT_DIR/logger.py" ]; then
    echo "Error: $LOGGER_SCRIPT_DIR/logger.py not found."
    exit 1
fi

while true; do
    python3 "$LOGGER_SCRIPT_DIR/logger.py"
    sleep $INTERVAL
done