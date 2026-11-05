#!/bin/bash
# sysinfo.sh - shows basic information about this system
# Author: Danny3637

echo "=== Hostname ==="
hostname

echo "=== User ==="
whoami

echo "=== Date ==="
date

echo "=== Uptime ==="
uptime -p

echo "=== IP addresses ==="
hostname -I

echo "=== Disk usage ==="
df -h /

echo "=== Memory ==="
free -h

echo "=== Top 5 processes (CPU) ==="
ps aux --sort=-%cpu | head -6
