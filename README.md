# Pi-Logger
## Readme for Raspberry Pi Diagnostics Logger

### Overview

This project provides a simple script for logging various system diagnostics on a Raspberry Pi. The script collects data such as CPU usage, memory usage, disk space, network statistics, and system temperature, and appends this information to a CSV file named `log_entries.csv`. If the CSV file does not exist, it will be created automatically.

### Prerequisites

- Raspberry Pi running Raspberry Pi OS (or any compatible Linux distribution with Systemctl/Systemd services and/or CRON setup enabled)
- Basic knowledge of Python Script Usage
- Basic knowledge of Bash Script Usage
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


### Explanation

- The script first imports the necessary modules: `os`, `csv`, `psutil`, and `datetime`.
- It defines the name of the CSV file to store the log entries.
- The script checks if the CSV file exists. If it does not, it creates the file and writes the header row with the column names.
- The `get_system_diagnostics` function collects various system metrics using the `psutil` library:
  - CPU usage as a percentage
  - Memory usage in megabytes
  - Disk usage as a percentage
  - Network statistics (bytes sent and received)
  - System temperature (for Raspberry Pi)
  - The function returns these metrics as a list.
  - The `log_data` function calls `get_system_diagnostics` to get the system metrics and appends them to the CSV file.
  - The script then runs the `log_data` function when executed directly (not imported as a module).
  - The script can be run manually or set up as a cron job to log the system diagnostics at regular intervals.


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

For more information on cron jobs, I've written a [README.md](./raspberry_pi_logger/autorun/cron/README.md) file in a [subdirectory](./raspberry_pi_logger/autorun/cron/.) on configuring cron jobs on a Raspberry Pi, including how to automate the script to run at regular intervals.
directory on configuring cron jobs on a Raspberry Pi, including how to automate the script to run at regular intervals.

Please note that the script is designed to run on a Raspberry Pi with the default configuration. If you are using a different system or have customized your setup, you may need to modify the script to work with your specific hardware and software configuration.

### Conclusion

The Raspberry Pi diagnostics logger provides a simple way to monitor system performance and collect data for analysis. By logging key metrics such as CPU usage, memory usage, disk space, network statistics, and system temperature, you can gain insights into the health and performance of your Raspberry Pi over time.

Feel free to modify the script to include additional diagnostics as needed!



## License

This project is licensed under the Creative Commons Attribution 4.0 International License.

Pi-Logger © 2024 by Robjects-Pi (Channels Robjects/RobjectsProjects) is licensed under CC BY 4.0 (Creative Commons Attribution 4.0 International License). To view a copy of this license, visit [https://creativecommons.org/licenses/by/4.0](https://creativecommons.org/licenses/by/4.0).

You are free to:
- Share — copy and redistribute the material in any medium or format
- Adapt — remix, transform, and build upon the material for any purpose, even commercially

Under the following terms:
- Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made.

## Related YouTube Content

This project is associated with two YouTube channels, both named X:

1. Robjects Channel:
   - Username: [Robjects]
   - [Robjects Channel](https://www.youtube.com/@Robjects)
   - Content focus: [Engineering projects from all areas of the engineering]

2. RobjectsProjects Channel:
   - Username: [RobjectsProjects]
   - [RobjectsProjects Channel](https://www.youtube.com/@RobjectsProjects
   - Content focus: [engineering projects from all areas of the engineerin focused more on technical aspects]

For the specific video related to this project, check out:
[Video Title]()

Both channels are managed by the same creator and often feature complementary content.

## Contact Information

For inquiries or feedback related to this project, please contact the creator via GitHub Discussions or the associated YouTube channels through the comments section or community tab.
