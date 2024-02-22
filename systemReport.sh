#!/bin/bash

# Taking the information of the OS running on the current system
# Name of the host
HostComputerName=$(hostname)
# Operating system running on the Computer
OperatingSystem=$(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')
# Since how long the system is running
Runtime=$(uptime -p)

# Taking the hardware configuration from systems
# CPU configuration
CPU=$(lshw -class cpu | awk '/product/ {print $2 " " $3}')
# Speed of CPU
SPEED=$(lshw -class cpu | awk '/capacity:/ {print $2}')
# Random access memory of the system
RAM=$(free -h | awk '/Mem:/ {print $2}')
# Disk on the System
SYSTEMDISKS=$(lsblk | grep disk | awk '{print $1 ": " $4}')
VIDEO=$(lshw -class display | awk '/product/ {print $2 " " $3}')

# Gathering the network information
# 1) Fully qualified domain name on the system gonna be
FQDN=$(hostname -f)
# IP address of the host on the system is as follows
HOSTADDRESS=$(ip a | awk '/inet / && !/127.0.0.1/ {split($2, a, "/"); print a[1]}')
# Taking the default gateway
IPGATEWAY=$(ip r | grep default | awk '{print $3}')
# DNS server IP address
IPOFDNS=$(nmcli dev show | awk '/DNS/ {print $2}')

# Interface Name
INTERFACE=$(ip -o link show | awk -F': ' '{print $2}')
# IP address of the given Interface
IPADDRESSOFINTERFACE=$(ip -o -4 addr show | awk '{print $4}')

# Taking System Running mode status
# User who is currently running the script
USERSNAME=$(who | awk '{print $1}' | sort | uniq | tr '\n' ',')
# Available space on the Disk
SPACEAVAILABLE=$(df -h --output=source,size | tail -n +2)
RUNNINGPROCESSOR=$(ps -e --no-header | wc -l)
LOADAVERAGES=$(cat /proc/loadavg | awk '{print $1 ", " $2 ", " $3}')
ALLOCATEDMEMO=$(free -h | awk '/Mem:/ {print $3 "/" $2}')
NETWORKLISTENINGPORTS=$(ss -tuln | awk '{print $5}' | grep -o '[0-9]\{1,5\}' | sort -n | uniq | tr '\n' ',')
RULESUFW=$(sudo ufw status numbered)

# Giving output of the system report
echo "
User $USER generating the report on the system at $(date)

System Info

Hostname: $HostComputerName
Operating System: $OperatingSystem
Uptime: $Runtime

Hardware Components

CPU: $CPU
Speed: $SPEED
RAM: $RAM
Disk(s): $SYSTEMDISKS
Video: $VIDEO

Network Configuration

FQDN: $FQDN
Host IP: $HOSTADDRESS
Default Gateway: $IPGATEWAY
DNS Server: $IPOFDNS
Interface Info: $INTERFACE
IP of Interface: $IPADDRESSOFINTERFACE

System Status
User Currently: $USERSNAME
Disk Space: $SPACEAVAILABLE
Count of Processes: $RUNNINGPROCESSOR
Average Load: $LOADAVERAGES
Memory Allocation: $ALLOCATEDMEMO
Listening Network Ports: $NETWORKLISTENINGPORTS
UFW: $RULESUFW
"
