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
