#!/bin/bash

#Author: VS
#Description: This script will install Jenkins on your Ubuntu Machine.


# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install Java (Jenkins requires Java)
if ! command_exists java; then
    echo "Installing Java..."
    sudo apt-get install -y openjdk-11-jdk
else
    echo "Java is already installed."
fi

# Add Jenkins repository and key
echo "Adding Jenkins repository and key..."
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update package list again after adding Jenkins repository
echo "Updating package list again..."
sudo apt-get update

# Install Jenkins
echo "Installing Jenkins..."
sudo apt-get install -y jenkins

# Start Jenkins service
echo "Starting Jenkins service..."
sudo systemctl start jenkins

# Enable Jenkins service to start on boot
echo "Enabling Jenkins service to start on boot..."
sudo systemctl enable jenkins

echo "Jenkins installation completed successfully."
echo "You can access Jenkins at http://<your_server_ip>:8080"

