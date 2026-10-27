# Week 02 Packet capture write-up
This week I was practiced capturing and reading my own network traffic with Wireshark to see how a device joins a network and loads a website.
I used my own home Wi-Fi network ony.
Tool: Wireshark (Npcap) on Windows 11
All MAC addresses have been removed from the screenshotts 192.168.x.x addresses are private and cant be reached from the internet

Summary:

#  |  Protocol  |  Wireshark filter      |  Port/Layer    |  Key finding
1  |  DHCP      |  dhcp                  |  UDP 67/68 - L7|  My router (192.168.100.1) leased my laptop 192.168.100.5/24 for ~2 days
2  |  ARP       |  arp                   |  L2 (no ports) |  "Who has ...?" request answered by an "is at" reply carrying the MAC
3  |  DNS       |  dns                   |  UDP 53 - L7   |  example.com -> 2 IPv4 addresses, answered by my router in ~9 ms
4  |  TCP       |  tcp.stream eq 60      |  TCP 443 -L4   |  3-way handshake SYN->SYN-ACK->ACK
5  |  HTTP      |  http                  |  TCP 80 - L7   |  Plain-text request and response headers, fully readable
6  |  TLS       | tls.handshake.type ==1 |  TCP 443 - L6/7|  Content encrypted, but the site name (SNI) is still visible


## How a web request travels


DHCP (get an IP) -> ARP (find router's MAC) -> DNS (name -> IP) -> TCP (3-way handshake) -> TLS (encrypt) -> HTTP (GET -> 200 OK)


## 1. DHCP: getting an address:


COMMANDS: 
  1. ipconfig /release
  2. ipconfig /renew
FILTER: dhcp
  
<img width="1577" height="352" alt="05-dhcp" src="https://github.com/user-attachments/assets/53f58025-1de4-4d21-8098-6f080a827684" />

Packet 267 is the Release from ipconfig /release: my laptop (192.168.100.5) tells the router it is giving its address back.
Then packets 362-365 follow DORA, all sharing Transaction ID 0xfa289691:

Packet  |  Message    |  Source -> Destination                              |  Meaning
362     |  Discover   |  0.0.0.0 -> 255.255.255.255                         |  "Is there a DHCP server?" Broadcast, because the laptop has no IP yet
363     |  Offer      |  192.168.100.1 -> 192.168.100.5                     |  The router offers 192.168.100.5
364     |  Request    |  0.0.0.0 -> 255.255.255.255                         |  "I'll take it." Still broadcast, so any other DHCP server knows its offer wasn't picked
365     |  ACK        |  192.168.100.1 -> 192.168.100.5                     |  Confirmed: the lease starts

The whole exchange took about 0.13 seconds. Client uses UDP 68, server UDP 67.

ipconfig /all confirmed the result: IPv4 192.168.100.5, mask 255.255.255.0 (/24), default gateway, DHCP server and DNS server all 192.168.100.1 (the home router), lease is approx 2 days.

<img width="1916" height="1005" alt="04-ipconfig-all" src="https://github.com/user-attachments/assets/7a77667e-876a-45c0-8fa7-e00ea214a539" />


## 2. ARP: Finding a MAC addres


Commands:
  1. arp -d *
  2. arp -a
FILTER: arp

<img width="1206" height="373" alt="06-arp" src="https://github.com/user-attachments/assets/6b6e64fa-9eed-4562-810d-a34faa01f0bc" />

ARP links an IP address to a MAC address on the local network. Packets 279 -> 280 are one request/reply pair:

Packet  |  Source -> Destination                |  Info                                          |  Meaning
279     |  Router (Fibrain)  ->  Laptop (Intel) |  Who has 192.168.100.5? Tell 192.168.100.1     |  The router checks my laptop's MAC
280     |  Laptop (Intel) -> router (Fibrain)   |  192.168.100.5 is at [MAC]                     |  My laptop answers with its MAC

The reply came about 0.00003 seconds. This request went straight to my laptop rather than to Broadcast, because the router already had my MAC cached and was just refreshing it. A first time request goes to ff:ff:ff:ff:ff:ff (everyone).

The same capture also shows:
  - A Samsung device (192.168.100.7) broadcasting "Who has 192.168.100.1?" every ~2 seconds. I only see it questions, not the router's answers, becuase replies are unicast to the asker.
  - A Ring device (192.168.100.10) sending an ARP Announcement 9gratutious ARP): tellingeveryone its IP and MAC without being asked. Attackers abuse exactly this kind of unasked-for ARP message for ARP spoofing.


## 3. DNS: turning a name into an IP


Command:
  1. nslookup example.com
FILTER: dns

<img width="1688" height="1016" alt="01-dns" src="https://github.com/user-attachments/assets/ca92d1e7-1f23-4222-8a05-0f15680043dd" />

Packets 60529 -> 60530 show my laptop (192.168.100.5) asking my router (192.168.100.1) for the A record (IPv4) of example.com over UDP port 53.
The router ansered with 172.66.147.243 and 104.20.23.154 in about 9ms.
The matching Transactions ID (0x0002) links the question to its answer, and the TTL of 183 seconds says how long the answer may be cached. nslookup also sent a PTR lookup for the DNS server itself ("No such name", which is noral) and an AAAA query for the IPv6 addresses.


## 4. TCP: the 3-way handshake


FILTER: tcp.stream eq 60

<img width="1682" height="1015" alt="03-tcp-synack" src="https://github.com/user-attachments/assets/bb1772f0-da07-4c34-aa6a-64077e3db7db" />

Packet  |  Direction            |  Flags            |  Meaning
38364   |  laptop -> server     |  0x002 SYN        |  "Can we talk?"
38365   |  server -> laptop     |  0x012 SYN, ACK  |  "Yes, I hear you"
38366   |  laptop -> server     |  ACK              |  "Confirmed"

Packets 38364-38366 show a TCP 3-way handshake between my laptop (192.168.100.5) and a Microsoft server (52.110.5.2) on port 443. The flags field proves it: the SYN packet has only the SYN bit set, and the reply has both SYN and ACK set.


## 5. HTTP: unencrypted web traffic


Site: http://neverssl.com
FILTER: http -> Follow -> TCP Stream

Following the TCP stream shows the whole conversation in plain text. My browser's request (red in Wireshark):

<img width="842" height="223" alt="Screenshot 2026-10-26 204459" src="https://github.com/user-attachments/assets/296f448e-27ac-4aac-97d2-609d70e39163" />

The servers response:

<img width="842" height="145" alt="Screenshot 2026-10-26 204507" src="https://github.com/user-attachments/assets/9b6f91cc-74c4-4bf7-9b44-b241a3b5728c" />

Everything is readable: the site, my browser and OS version, my language, and the server software and version.
The page body itself looked like gibberish, but that's gzip compression, not encryption.
Wireshark can decompress it, and so could anyone else on the network. Anyone on the same network could read this.


## 6. TLS: encrypted web traffic


Site: https://neverssl.com
FILTER: tls.handshake.type == 1

<img width="1622" height="876" alt="08-tls" src="https://github.com/user-attachments/assets/236ca022-7310-459d-8b3a-c01b1dfcb215" />

Packet 855 is a TLS 1.3 Client Hello from my laptop to 34.223.124.45. 
Expanding Extension: server_name shows Server Name: neverssl.com in plain text.
This is the SNI, sent before encryption starts so the server knows which certificate to use.
After the Server Hello, every packet is "Application Data": encrypted and unreadable.

Two surprises:
  1. My browser tried HTTPS first even on a site built to be HTTP-only. Modern browsers attempt HTTPS before falling back to HTTP.
  2. QUIC rows also matched the filter. QUIC (used by Google, 142.250.x.x) runs TLS 1.3 over UDP instead of TCP, so its Client Hellos show up too.

Why this matters for security?

  1. HTTP is readable by anyone on the network, including passwords on old login forms. Alsways use HTTPS.
  2. TLS hides the content but not the destination: the SNI and the DNS lookup still reveal which site I visited.
  3. DNS is unencrypted, so lookups can be watched or spoofed (defences: DNS over HTTPS/TLS, DNSSEC).
  4. ARP and DHCP have no authentication. An attacker on the LAN can fake ARP replies (ARP spoofing -> man-in-the-middle) or run a rogue DHCP server that hands out a fake gateway/DNS.
  5. Packet captures contain identifying data (MACaddresses, internal IPs), so I removed MACs before pusblishing.
