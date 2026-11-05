# Week 02 - Session 1 Terminal Notes
Final goal
Find out, from my own laptop, how it joined the network:
  - which DHCP server gave it an IP address, and how long the lease lasts
  - which DNS server it uses to turn names into IP addresses
... and check this matches what I saw in Wireshark (router 192.168.100.1 answering DNS on UDP 53).


## Commands, in order


Run in Windows Terminal (PowerShell)

#  |  Command                      |  What id does                                                                     |  Status
1  |  nslookup bbc.co.uk           |  Asks my DNS server for bbc.co.uk's IP address (A/AAAA records)                   |  add output
2  |  nslookup -type=mx gmail.com  |  Asks which mail servers recieve eail for gmail.com (MX records)                  |  add output
3  |  ipconfig /all                |  Shows the full network config for every adapter: IP, mask, gateway, DHCP and DNS |  Done


## What ipconfig /all showed


<img width="1916" height="1005" alt="04-ipconfig-all" src="https://github.com/user-attachments/assets/3cc4e474-edd6-42c0-8f51-9ca10bb5913c" />

Use the "Wireless LAN adapter Wi-Fi" section. the "Local Area Conncetion" adapters are unused Wi-Fi Direct virtual adapters (Media disconnected)

Field              |  Value                                  |  Meaning
IPv4 Address       |  192.168.100.5                          |  My laptop's private IP
Subnet Mask        |  255.255.255.0                          |  /24 -> 254 usable ports
Default Gateway    |  192.168.100.1                          |  My router, theway out to the internet
DHCP Server        |  192.168.100.1                          |  The router handed out my IP
Lease              |  19 Oct 21:02 -> 21 Oct 18:41 (~2 days) |  How long I can keep the IP. Windows renews it automatically about halfway through.
DNS Servers        |  192.168.100.1                          |  The router also answers my DNS lookups
Link-local IPv6    |  fe80::...                              |  Automatic local-only IPv6 addressess

### Summary: 

My laptop got 192.168.100.5/24 from the DHCP server on my router (192.168.100.1). 
The lease lasts about 2 days, and the same router is my default gateway and DNS server. 
This matches the Wireshark capture, where DNS answers came from 192.168.100.1 on UDP 53.
