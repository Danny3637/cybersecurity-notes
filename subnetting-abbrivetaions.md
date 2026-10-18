Subnetting abbreviations 

[Week 1]

[1. Models & basics] 
[2. Network types & devices] 
[3. Addressing & subnetting]
[4. Transport Layer (TCP/UDP)]
[5. DNS]
[6. Protocols & their ports]


1. Models & basics

Abbreviation  |                         Stands For                          |                  What it means
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
OSI           |      Open Systems Interconnection                           |  The 7-layer reference model (Physical -> Application) used to describe and troubleshoot networks
TCP/IP        |      Transmission Control Protocol                          |  The 4-layer model the internet actually runs on (Link, Internet, Transport, Application)
PDU           |      Protocol Data Unit                                     |  The names of the data "chunk" at each layer: bits -> frames -> packets -> segments/datagrams -> data
IP            |      Internet Protocol                                      |  Layer 3 protocol that addresses and routes packets between networks
IPv4/IPv6     |      Internet Protocol version 4/6                          |  32-bit addresses (192.168.1.10) / 128-bit addresses (2001:db8::1)
MAC           |      Media Access Control (address)                         |  48-bit hardware address burned into a network card, used on the local network (Layer 2) 
NIC           |      Network Interface Card                                 |  The network adapter (wired or Wi-Fi) in a device
FCS           |      Frame Check Sequence                                   |  Error-check value at the end of an Ethernet frame
TTL           |      Time To Live                                           |  Hop counter on a packet (or how long a DNS record is cached); stops packets looping forever
ASCII         |      American Standard Code for Information Interchange     |  Text encoding; a Presentation-layer (L6) example
JPEG          |      Joint Photographic Experts Group                       |  Image format; another Presentation-layer (L6) example


2. Network types & Devices


Abbreviation  |                         Stands For                          |                  What it means
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
LAN           |      Local Area Network                                     |  Network in one place (home, office)
WAN           |      Wide Area Network                                      |  Network connecting sites over long distances; the internet is the biggest WAN
VLAN          |      Virtual LAN                                            |  Splits one physical switch into separate logical networks (e.g. guest vs staff)
AP/WAP        |      (Wireless) Access Point                                |  Device that lets Wi-Fi clients join a wired network
ISP           |      Internet Service Provider                              |  Your internet company (BT, Virgin...)
VPN           |      Virtual Private Network                                |  Encrypted tunnel over the internet to another network
NAT           |      Network Address Translation                            |  Router swaps private IP's for one public IP so private devices can reach the internet


3. Addressing & subnetting


Abbreviation  |                         Stands For                          |                  What it means
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CIDR          |      Classless Inter-Domain Routing                         |  The /Prefix notation (e.g. /27) instead of old Class A/B/C
ID(Network ID)|      Network Identifier                                     |  First address of a subnet; identifies the subnet, not usable by a host
DHCP          |      Dynamic Host Configuration Protocol                    |  Hands out IP address, mask, gateway and DNS automatically (UDP 67/68)
DORA          |      Discover, Offer, Request, Acknowledge                  |  The 4 steps of getting an address from DHCP
APIPA         |      Automatic Private IP Addressing                        |  169.254.x.x address a device gives itself when DHCP fails
ARP           |      Address Resolution Protocol                            |  Finds the MAC address for a known IP on the local network
ICMP          |      Internet Control Message Protocol                      |  Error/Diagnostic Messages; used by *ping* and *traceroute* (no ports)


4. Transport Layer (TCP/UDP)


Abbreviation  |                         Stands For                          |                  What it means
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
TCP           |      Transmission Control Protocol                          |  Connection-oriented, reliable, ordered delivery (web, email, SSH)
UDP           |      User Datagram Protocol                                 |  Connectionless, fast, no delivery guarantee (DNS queries, streaming, VoIP)


5. DNS


Abbreviation  |                         Stands For                          |                  What it means
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DNS           |      Domain Name System                                     |  Turns names (google.com) into IP addresses (UDP/TCP 53)
TLD           |      Top-Level Domain                                       |  Last part of a name: .com, .uk, .org
SLD           |      Second-Level Domain                                    |  The part before the TLD: google in google.com
A             |      Address record                                         |  Name -> IPv4 address
AAAA          |      "Quad-A" Record                                        |  Name -> IPv6 address
CNAME         |      Canonical Name                                         |  Alias pointing one name to another name
MX            |      Mail Exchange                                          |  Which server receives email for the domain
NS            |      Name Server                                            |  Which servers are authoritative for the domain
PTR           |      Pointer                                                |  Reverse lookup: IP -> name
TXT           |      Text record                                            |  Free text: used for SPF, DKIM, domain verification
SPF           |      Sender Policy Framework                                |  TXT record listing servers allowed to send email for a domain
DKIM          |      DomainKeys Identified Mail                             |  Digital signature proving an email really came from the domain


6. Protocols & their Prots


Abbreviation  |                         Stands For                          |                  What it means                                                         |      Port
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
FTP           |      File Transfer Protocol                                 |  File Transfer, unencrypted                                                            | TCP 20/21
SSH           |      Secure Shell                                           |  Encrypted remote command line                                                         | TCP 22
SFTP          |      SSH File Transfer Protocol                             |  Encrypted file transfer over SSH                                                      | TCP 22
SCP           |      Secure Copy Protocol                                   |  Copies files over SSH                                                                 | TCP 22
SMTP          |      Simple Mail Transfer Protocol                          |  Sends email between servers                                                           | TCP 25 (587 submission)
SMTPS         |      SMTP Secure                                            |  SMTP over TLS                                                                         | TCP 465
STARTTLS      |      (command, "start TLS")                                 |  Upgrades a plain connection (SMTP/IMAP/POP3)                                          | ---
HTTP          |      Hypertext Transfer Protocol                            |  Web traffic, unencrypted                                                              | TCP 80
HTTPS         |      HTTP Secure                                            |  Web traffic over TLS                                                                  | TCP 443
TLS SSL       |      Transport Layer Security/Secure Sockets Layer          |  Encryption for HTTPS etc., SSL is the old, insecure predecessor                       | ---
TFTP          |      Trivial File Transfer Protocol                         |  Simple, no login file transfer (network device configs)                               | UDP 69
POP3 POP3S    |      Post Office Protocol v3 (Secure)                       |  Downloads email to one device                                                         | TCP 110 / 995
IMAP IMAPS    |      Internet Message Access Protocol (Secure)              |  Syncs email across devices                                                            | TCP 143 / 993
NTP           |      Network Time Protocol                                  |  Keeps clock in sync (matters for logs!)                                               | UDP 123
RPC           |      Remote Procedure Call                                  |  Lets programs run functions on another machine                                        | TCP 135 (MS RPC)
NetBIOS       |      Network Basic Input/Output System                      |  Old Windows name/file-sharing services                                                | 137 - 139
SNMP          |      Simple Network Managements Protocol                    |  Monitors and manages network devices                                                  | UDP 161/162
LDAP LDAPS    |      Lightweight Directory Access Protocol (Secure)         |  Queries directories like Active Directory                                             | TCP 389 / 636
SMB           |      Server Message Block                                   |  Windows file and printer sharing                                                      | TCP 445
MS SQL MySQL  |      Microsoft SQL Server / MySQL                           |  Database servers (SQL = Structured Query Language)                                    | TCP 1433 / 3306
PPTP          |      Point-to-Point Tunnelling Protocol                     |  Old VPN protocol, Insecure                                                            | TCP 1723
RDP           |      Remote Desktop Protocol                                |  Windows remote desktop                                                                | TCP 3389
SIP           |      Session Initiation Protocol                            |  Sets up VoIP calls                                                                    | 5060/5061
VoIP          |      Voice over IP                                          |  Phone calls over the network                                                          | ---
IPsec         |      IP Security                                            |  Encrypts IP traffiic; common in site-to-site VPNs                                     | UDP 500/4500
---           |      OpenVPN / WireGuard (names, not abbriveations)         |  Modern VPN protocols                                                                  | UDP 1194/51820
