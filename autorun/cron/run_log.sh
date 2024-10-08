#!/bin/bash

LOGGER_SCRIPT_DIR="/home/pi/raspberry_pi_logger"


if [ ! -f "$LOGGER_SCRIPT_DIR/logger.py" ]; then
    echo "Error: $LOGGER_SCRIPT_DIR/logger.py not found."
    exit 1
fi

while true; do
    python3 "$LOGGER_SCRIPT_DIR/logger.py"
done