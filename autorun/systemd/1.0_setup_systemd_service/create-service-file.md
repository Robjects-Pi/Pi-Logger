# Setting Up a Systemd Service for a Raspberry Pi 


In this guide, we'll cover how to set up the Raspberry Pi diagnostics logger to autorun at reboot using systemd. We'll create a systemd service file for the logger, enable and start the service, and provide scripts for managing the autorun process.

By configuring the Raspberry Pi diagnostics logger as a systemd service, you can ensure that the logger starts automatically at system boot and runs continuously in the background. This approach provides a more robust and integrated solution compared to using cron jobs for autorun tasks.
Logger
For this setup, you'll need to have sudo privileges to create and manage systemd services.



Here's the `run_systemd_service.sh` script:

```bash
#!/bin/bash

# run_systemd_service.sh
# This script sets up a systemd service to run the Raspberry Pi logger every 5 seconds.
# It also checks for the logger.py file and copies the repository if missing.

# Set variables
USER=$(whoami)
REPO_URL="https://github.com/yourusername/Pi-Logger.git"
INSTALL_DIR="/home/$USER/Pi-Logger"
LOGGER_DIR="/home/$USER/raspberry_pi_logger"
LOGGER_SCRIPT="$LOGGER_DIR/logger.py"
SERVICE_NAME="pi-logger"

# Function to check and clone the repository
check_and_clone_repo() {
    if [ ! -f "$LOGGER_SCRIPT" ]; then
        echo "Logger script not found. Cloning the repository..."
        git clone "$REPO_URL" "$INSTALL_DIR"
        echo "Repository cloned successfully."
    fi
}

# Function to create the systemd service file
create_systemd_service() {
    cat << EOF | sudo tee /etc/systemd/system/$SERVICE_NAME.service > /dev/null
[Unit]
Description=Raspberry Pi Logger Service
After=network.target

[Service]
ExecStart=/bin/bash -c "while true; do python3 $LOGGER_SCRIPT; sleep 5; done"
WorkingDirectory=$LOGGER_DIR
User=$USER
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    echo "Systemd service file created."
}

# Function to add logger directory to PATH
add_to_path() {
    if ! grep -q "$LOGGER_DIR" ~/.bashrc; then
        echo "export PATH=\$PATH:$LOGGER_DIR" >> ~/.bashrc
        echo "Logger directory added to PATH. Please restart your terminal or run 'source ~/.bashrc' to apply changes."
    else
        echo "Logger directory already in PATH."
    fi
}

# Main execution
check_and_clone_repo
create_systemd_service
add_to_path

# Enable and start the service
sudo systemctl enable $SERVICE_NAME
sudo systemctl start $SERVICE_NAME

echo "Raspberry Pi Logger service has been set up and started."
echo "You can check its status with: sudo systemctl status $SERVICE_NAME"
```

### How to Use This Script

1. Save this script as `run_systemd_service.sh` in your home directory or any preferred location.

2. Make the script executable:
   ```bash
   chmod +x run_systemd_service.sh
   ```

3. Run the script:
   ```bash
   ./run_systemd_service.sh
   ```

### What This Script Does

1. **Checks for Logger Script**: It verifies if `logger.py` exists in the specified directory.

2. **Clones Repository**: If `logger.py` is not found, it clones the entire repository from the specified GitHub URL.

3. **Creates Systemd Service**: Sets up a systemd service that runs the logger every 5 seconds.

4. **Adds to PATH**: Adds the logger directory to the system PATH by modifying `.bashrc`.

5. **Enables and Starts Service**: Enables the service to start on boot and starts it immediately.

### Customization

- **Repository URL**: Replace `https://github.com/yourusername/Pi-Logger.git` with the actual URL of your repository.
- **Installation Directory**: The script uses `/home/$USER/Pi-Logger`. Modify if you prefer a different location.
- **Service Name**: The service is named `pi-logger`. You can change this in the `SERVICE_NAME` variable if desired.

### Notes

- This script requires sudo privileges to create and manage the systemd service.
- After running the script, you may need to restart your terminal or run `source ~/.bashrc` to update your PATH.
- The systemd service will automatically restart if it fails, ensuring continuous logging.
- You can modify the sleep duration in the systemd service file to change how often the logger runs.

This setup provides a robust way to ensure your Raspberry Pi logger is always running and easily accessible from anywhere in the system.

# Next Steps

- **