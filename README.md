# Pi-Logger
## Readme for Raspberry Pi Diagnostics Logger

### Overview

This project provides a simple script for logging various system diagnostics on a Raspberry Pi. The script collects data such as CPU usage, memory usage, disk space, network statistics, and system temperature, and appends this information to a CSV file named `log_entries.csv`. If the CSV file does not exist, it will be created automatically.

### Prerequisites

- Raspberry Pi running Raspberry Pi OS (or any compatible Linux distribution)
- Python 3 installed
- Basic knowledge of using the terminal

### Installation

1. **Update your system**: Before starting, ensure your Raspberry Pi is up to date.
   ```bash
   sudo apt update
   sudo apt upgrade
   ```

2. **Install required packages**: You may need to install the `psutil` library for system monitoring.
   ```bash
   sudo apt install python3-pip
   pip3 install psutil
   ```

3. **Download the script**: Create a directory for your project and download the script.
   ```bash
   mkdir ~/raspberry_pi_logger
   cd ~/raspberry_pi_logger
   nano logger.py
   ```

4. **Copy the script**: Paste the provided Python script into the `logger.py` file and save it.

### Usage

To run the logger, simply execute the script using Python. The script will automatically log the diagnostics to `log_entries.csv`.

```bash
python3 logger.py
```

You can set up a cron job to run this script at regular intervals (e.g., every hour) for continuous monitoring.

### Script

Here is the complete script for the Raspberry Pi diagnostics logger:

```python
import os
import csv
import psutil
from datetime import datetime

# Define the CSV file name
csv_file = 'log_entries.csv'

# Check if the CSV file exists, if not, create it and write the header
if not os.path.exists(csv_file):
    with open(csv_file, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['Timestamp', 'CPU Usage (%)', 'Memory Usage (MB)', 'Disk Usage (%)', 'Network Sent (bytes)', 'Network Received (bytes)', 'Temperature (°C)'])

# Function to get system diagnostics
def get_system_diagnostics():
    # Get current timestamp
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    # Get CPU usage
    cpu_usage = psutil.cpu_percent(interval=1)

    # Get memory usage
    memory_info = psutil.virtual_memory()
    memory_usage = memory_info.used / (1024 * 1024)  # Convert bytes to MB

    # Get disk usage
    disk_info = psutil.disk_usage('/')
    disk_usage = disk_info.percent

    # Get network statistics
    net_info = psutil.net_io_counters()
    network_sent = net_info.bytes_sent
    network_received = net_info.bytes_recv

    # Get temperature (for Raspberry Pi)
    try:
        with open('/sys/class/thermal/thermal_zone0/temp') as temp_file:
            temperature = float(temp_file.read()) / 1000  # Convert from millidegrees to degrees Celsius
    except FileNotFoundError:
        temperature = None

    return [timestamp, cpu_usage, memory_usage, disk_usage, network_sent, network_received, temperature]

# Main function to log the data
def log_data():
    diagnostics = get_system_diagnostics()
    with open(csv_file, mode='a', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(diagnostics)

if __name__ == '__main__':
    log_data()
```

### Running the Script

- To run the script manually, use the command:
  ```bash
  python3 logger.py
  ```

- To set up a cron job:
  ```bash
  crontab -e
  ```
  Add the following line to run the script every hour:
  ```bash
  0 * * * * /usr/bin/python3 /home/pi/raspberry_pi_logger/logger.py
  ```

### Conclusion

This Raspberry Pi diagnostics logger is a simple yet effective way to monitor your system's health over time. The data collected can be useful for troubleshooting and performance monitoring. 

Feel free to modify the script to include additional diagnostics as needed!