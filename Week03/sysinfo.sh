#!/bin/bash
#==========================================================
# sysinfo.sh - shows basic system and security info
# Author: Danny3637
# Usage: chmod +x sysinfo.sh && ./sysinfo.sh
#==========================================================

# Which machine this is:
echo "=== Hostname ==="
hostname

# Which user is running the script
echo "=== User ==="
whoami

# Current date and time
echo "=== Date ==="
date

# How long the machine has been on 
echo "=== Uptime ==="
uptime -p

#All IP addresses (NAT, lab netwrok, IPv6)
echo "=== IP addresses ==="
hostname -I

# Free space ont he main drive (-h = human readable)
echo "=== Disk usage ==="
df -h /

# RAM used and free
echo "=== Memory ==="
free -h

# The 5 busiest processes (header + 5 lines)
echo "=== Top 5 processes (CPU) ==="
ps aux --sort=-%cpu | head -6

# Security: who is logged in right now
echo "=== Logged-un users ===="
who

# Security: ports this machine is listening on (open doors)
echo "=== Listening ports ==="
ss -tuln

