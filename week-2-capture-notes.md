# Week 2 Capture Notes

## 1 DNS Lookup

Command:
nslookup example.com
Filter: dns

<img width="1688" height="1016" alt="01-dns" src="https://github.com/user-attachments/assets/1dcae3c6-f1b5-441b-b740-8e58f0b59150" />

Packets          |  Question -> Answer
60525 -> 60528   |  PTR 1.100.168.192.in-addr.arpa : nslookup asks for the DNS server's own name. "No such name" (the router has none, it is normal)
60529 -> 60530   |  A example.com (IPv4) -> 172.66.147.243, 104.20.23.154 (TTL 183 s)
60531 -> 60532   |  AAAA example.com (IPv6) -> 2606:4700:10::6814:179a , 2606:4700:10::ac42:93f3

Packets 60529 -> 60530 show a DNS lookup over UDP port 53. My laptop (192.168.100.5) asks my router (192.168.100.1), which acts as my DNS server, for the IPv4 address of example.com. 
The router answers with two A records in about 9 ms. 
The matching Transaction ID (0x0002) links the question to its answer, and the TTL of 183 seconds says how long the answer can be cached.
--------------------------------------------------------------------------------------------------------------------------------------------------------
Security note: 
DNS is unencrypted, so anyone on the network can see which sites I look up. DNS spoofing (fake answers) is possible for the same reason.
--------------------------------------------------------------------------------------------------------------------------------------------------------

## 2. TCP 3-way handshake + start of TLS

Filter: tcp.stream eq 60
Capture: home Wi-Fi, Wireshark

<img width="1677" height="1017" alt="02-tcp-syn" src="https://github.com/user-attachments/assets/c6e11dec-1287-4e36-afb4-33fa20eef76d" />

<img width="1682" height="1015" alt="03-tcp-synack" src="https://github.com/user-attachments/assets/1c3cea1f-6e3d-4d78-b842-3dbc5107355c" />

Packet        |  Direction          |  Flags            |  Meaning
38364         |  laptop -> server   |  0x002 SYN        |  "Hello, can we talk?"
38365         |  server -> laptop   |  0x012 SYN, ACK   |  "Yes, I hear you"
38366         |  laptop -> server   |  ACK              |  "Confirmed, let's talk"
38367         |  laptop -> server   |  TLS Client Hello |  Start encryption (SNI: officeclient.microsoft.com)

Packets 38364 -> 38366 show a TCP 3-way handshake between my laptop (192.168.100.5) and a Microsoft server (52.110.5.2) on port 443. 
My laptop sends SYN, the server replies SYN -> ACK, and my laptop confirms with ACK. 
Packet 38367 then starts the TLS handshake (Client Hello, SNI officeclient.microsoft.com), after which all data is encrypted.
-------------------------------------------------------------------------------------------------------------------------------
Security note: 
The content is encrypted, but the SNI in the Client Hello still shows which site I connected to.
-------------------------------------------------------------------------------------------------------------------------------
