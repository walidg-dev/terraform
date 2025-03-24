#!/bin/bash

sudo apt update -y

# Add Docker's official GPG key:
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

# Install docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Install Java 17
wget -O - https://apt.corretto.aws/corretto.key | sudo gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg && \
echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | sudo tee /etc/apt/sources.list.d/corretto.list

sudo apt update; sudo apt install -y java-17-amazon-corretto-jdk

# Install git
sudo apt install git -y

# Create data folder for postgresql
cd /home/ubuntu/
mkdir data

# Generate random password
db_password=$(tr -dc 'A-Za-z0-9!?%=' < /dev/urandom | head -c 10)
echo "$db_password" > mypassword.txt

db_host=localhost
db_name=user_db
db_user=postgres

# Run postgresql
cd /home/ubuntu/
git clone https://github.com/walidg-dev/dockerized-services.git
cd dockerized-services/postgres-service
sudo user="$db_user" pw="$db_password" db="$db_name" data="/home/ubuntu/data" docker compose up -d --wait

# Run micro service
cd /home/ubuntu/
git clone https://github.com/walidg-dev/user-service.git
cd user-service
sudo DB_HOST="$db_host" DB_NAME="$db_name" DB_USER="$db_user" DB_PASSWORD="$db_password" ./gradlew bootRun
