#!/bin/bash

#Author: VS
#Description: This script will create the master and slave(Agent) configuration on your jenkins machine

# Variables
MASTER_IP="your_master_ip"
AGENT_NAME="your_agent_name"
JENKINS_USER="jenkins"
JENKINS_HOME="/var/lib/jenkins"
JENKINS_URL="http://$MASTER_IP:8080"
AGENT_WORK_DIR="/home/$JENKINS_USER/$AGENT_NAME"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Java
if ! command_exists java; then
    echo "Installing Java..."
    sudo apt-get update
    sudo apt-get install -y openjdk-11-jdk
else
    echo "Java is already installed."
fi

# Create Jenkins user
if ! id -u $JENKINS_USER >/dev/null 2>&1; then
    echo "Creating Jenkins user..."
    sudo useradd -m -s /bin/bash $JENKINS_USER
else
    echo "Jenkins user already exists."
fi

# Generate SSH keys
if [ ! -f /home/$JENKINS_USER/.ssh/id_rsa ]; then
    echo "Generating SSH keys..."
    sudo -u $JENKINS_USER ssh-keygen -t rsa -b 2048 -N "" -f /home/$JENKINS_USER/.ssh/id_rsa
    echo "Copy the following public key to the Jenkins master node:"
    cat /home/$JENKINS_USER/.ssh/id_rsa.pub
else
    echo "SSH keys already exist."
fi

# Create agent work directory
if [ ! -d $AGENT_WORK_DIR ]; then
    echo "Creating agent work directory..."
    sudo -u $JENKINS_USER mkdir -p $AGENT_WORK_DIR
else
    echo "Agent work directory already exists."
fi

# Download agent.jar from Jenkins master
echo "Downloading agent.jar from Jenkins master..."
sudo -u $JENKINS_USER wget -O $AGENT_WORK_DIR/agent.jar $JENKINS_URL/jnlpJars/agent.jar

# Start Jenkins agent
echo "Starting Jenkins agent..."
sudo -u $JENKINS_USER nohup java -jar $AGENT_WORK_DIR/agent.jar -jnlpUrl $JENKINS_URL/computer/$AGENT_NAME/agent-agent.jnlp -secret @/home/$JENKINS_USER/.jenkins/$AGENT_NAME-secret-file &

echo "Jenkins agent setup completed."

