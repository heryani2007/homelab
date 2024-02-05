#!/bin/bash

# Step 1: Download Splunk SOAR
curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=1o5vKAAgLG2PRsOAu3FlH3nCQYFRtY0E2" > /dev/null
curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=$(awk '/download/ {print $NF}' ./cookie)&id=1o5vKAAgLG2PRsOAu3FlH3nCQYFRtY0E2" -o splunk_soar-unpriv-6.2.0.355-8f22f289-el8-x86_64.tgz

# Step 2: Create and configure user phantom
sudo adduser phantom --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "phantom:K1llz0n3#12" | sudo chpasswd
sudo usermod -aG wheel phantom

# Step 3: Extract Splunk SOAR and move to /opt
tar -xzvf splunk_soar-unpriv-6.2.0.355-8f22f289-el8-x86_64.tgz
sudo mv splunk_soar /opt/phantom

# Step 4: Run soar-prepare-system as root
sudo /opt/phantom/soar-prepare-system -y

# Step 5: Run soar-install as phantom
sudo -u phantom /opt/phantom/soar-install -y

echo "Splunk SOAR installation process completed."
