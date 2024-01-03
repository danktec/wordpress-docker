#!/bin/bash
echo "Starting UserData Script $(date -R)"

echo "Installing packages"
apt-get install iptables net-tools vim htop git python3-pip curl certbot -y

## Set up docker on Debian
apt-get update
apt-get install ca-certificates curl gnupg -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update

apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "Completed at $(date -R)"

## Set db password
export WORDPRESS_DB_PASSWORD=`date +%s | sha256sum | base64 | head -c 20`