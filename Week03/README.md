# Week 03 - Linux & VM's

## sysinfo.sh
A bash script that prints a quick system and security of a Linux machine:
hostname, user, date, uptime, IP address, disk memore, the busiest processes, logged-in users and listening ports.

## How to run it
	chmod +x sysinfo.sh
	./sysinfo.sh

Save the output to a file

	./sysinfo.sh > sample-output.txt

## Sample output

	see [sample-output.txt](sample-output.txt)

## What each check is for

| Section | Command | Why |
|---|---|---|
| Logged-in users | 'who' | spot unexpected logins |
| Listening ports | |'ss -tuln' | every port is a possible way in |
| Top processes | 'ps aux --sort=-%cpu' | find something using too much CPU (e.g. a crypto miner) |

## Lab used

Two kali Linux VMs in VirtualBox on an internal network (10.10.10.0/24).

## What i learned

- How to write and run bash scripts in Kali, and what each command means
- A script won't run untill it has execute permission ('chmod +x'), and it need '#!/bin/bash'
- Error messages tell you where to look: the line number helped me find a typo ('fir' instead of 'for')
- Kali's terminal uses zsh, which counts arrays from 1, while bash scripts count from 0
- 'who' and 'ss -tuln' are quick security checks: they show who is logged in and whcih ports are open
