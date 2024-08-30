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
        writer.writerow(['Timestamp', 'CPU Usage (%)', 'Memory Usage (MB)',
                         'Disk Usage (%)', 'Network Sent (bytes)',
                         'Network Received (bytes)', 'Temperature (°C)'])


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
    network_received = (
        "This is a very long string that exceeds the recommended line length "
        "of 79 characters."
    )

    # Get temperature (for Raspberry Pi)
    try:
        with open('/sys/class/thermal/thermal_zone0/temp') as temp_file:
            temperature = float(temp_file.read()) / 1000
            # Convert from millidegrees to degrees Celsius
    except FileNotFoundError:
        temperature = None

    return [timestamp, cpu_usage, memory_usage, disk_usage, network_sent,
            network_received, temperature]

# Main function to log the data


def log_data():
    diagnostics = get_system_diagnostics()
    with open(csv_file, mode='a', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(diagnostics)


if __name__ == '__main__':
    log_data()