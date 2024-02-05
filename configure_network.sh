#!/bin/bash

# Function to get current network settings
get_current_settings() {
    echo "Current IP address settings for $1:"
    ip addr show $1
    echo "Current route settings:"
    ip route
    echo "Current DNS settings:"
    if [ -f /etc/resolv.conf ]; then
        cat /etc/resolv.conf
    else
        echo "DNS settings not found in /etc/resolv.conf"
    fi
}

# Function to configure RHEL
configure_rhel() {
    read -p "Enter the interface name (e.g., ens18): " interface
    get_current_settings $interface

    read -p "Enter the static IP address (e.g., 192.168.254.13/24): " ipaddr
    read -p "Enter the gateway (e.g., 192.168.254.254): " gateway
    read -p "Enter the DNS server (e.g., 192.168.1.1): " dns

    nmcli dev disconnect $interface
    nmcli con mod $interface ipv4.addresses $ipaddr
    nmcli con mod $interface ipv4.gateway $gateway
    nmcli con mod $interface ipv4.dns $dns
    nmcli con mod $interface ipv4.method manual
    nmcli con up $interface

    echo "RHEL Network Configuration Updated."
}

# Function to configure Ubuntu
configure_ubuntu() {
    read -p "Enter the interface name (e.g., ens18): " interface
    get_current_settings $interface

    read -p "Enter the netplan configuration file (e.g., /etc/netplan/01-netcfg.yaml): " netplan_file
    read -p "Enter the static IP address (e.g., 192.168.254.13/24): " ipaddr
    read -p "Enter the gateway (e.g., 192.168.254.254): " gateway
    read -p "Enter the DNS server (e.g., 192.168.1.1): " dns

    echo "network:
  version: 2
  renderer: networkd
  ethernets:
    $interface:
      dhcp4: no
      addresses:
        - $ipaddr
      gateway4: $gateway
      nameservers:
        addresses:
          - $dns" | sudo tee $netplan_file

    sudo netplan apply
    echo "Ubuntu Network Configuration Updated."
}

# List all network interfaces
echo "Available network interfaces:"
ip link show

# Detecting OS Type
os_type=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

if [[ $os_type == *"Ubuntu"* ]]; then
    echo "Ubuntu detected"
    configure_ubuntu
elif [[ $os_type == *"Red Hat"* ]]; then
    echo "Red Hat Enterprise Linux detected"
    configure_rhel
else
    echo "Unsupported OS"
fi
