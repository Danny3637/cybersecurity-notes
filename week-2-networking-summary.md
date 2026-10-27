# Week 2 Networking Lessons Summary
19-25th Oct 2026:
  - unicast/multicast/anycast/broadcast
  - DHCP
  - DNS reecords
  - NAT & ICMP
  - HTTPS(S)
  - TLS
  - a web request end to end
  - Wireshark
  - commands
  - self-test

    Session        |                                                What was covered                                                                                 |                  Resources
Tue - 1            |  DNS records, DHCP (DORA, relay, leases,  scopes) network communication types, HTTP, /nslookup + /ipconfig /all                                 |  ProfessorMesser: DNS Records, DHCP, Configuring DHCP, Network Communciation. THM: HTTP in Detail
Tue - 2            |  NAT, ICMP, how websites work, a web request end to end                                                                                         |  ProfessorMesser: Network Address Translation, Other Useful Protocols. THM: How Websites Work
Thu - 3            |  Reading packets in Wireshark: DORA, DNS query/response pairs, TCP stream, statistics                                                           |  Wireshark Wiki sample captures: dhcp.pcap, dns.cap, http.cap
Thu - 4            |  Capturing your own traffic: DHCP renew, ARP, DNS, TCP handshake, HTTP vs HTTPS                                                                 |  Wireshark + Terminal on your own Wi-Fi
Sat - Lab          |  Packet-capture write-up published to GitHub + knowledge check                                                                                  |  Portfolio/week 2. ProProfs N10-009 + ports quizzes


## Four ways to send data


Every packett is addressed to one, some, the nearest one or all devices.

Unicast   - one -> one                  : Web, email, file transfer
Multicast - one -> subscribers          : Streaming, stock feeds, routing updates
Anycasat  - one -> nearest of many      : Anycast DNS
Broadcast - one -> everyone on the LAN  : ARP, DHCP Discover (not in IPv6)

- Unicast to many people = many copies (one per person). Thats why streaming at scale uses multicast or CDNs.
- Broadcasts never cross a router. They stay inside the local network (the broadcast domain).
- IPv6 has no broadcast. It uses multicast for jobs like finding neighhbours.

------------------------------------------------------------------------------------------------------------------------
Security angle:
Broadcasts reach every device on the LAN, so anyone listening sees the.
That's why you could see your neighbours ARP "Who has...?" requests in Wireshark, but not their replies (those are unicast).
------------------------------------------------------------------------------------------------------------------------


## DHCP: automatic IP settings (UDP 67/68)


Dynamic Host Configuration Protocol hands a device its IP address, subnet mask, default gateway and DNS server for a set time (the lease).
It replaced the older BOOTP.
Server = UDP 67, Client = UDP 68

### DORA, step by step

Client no IP                                                         DHCP server
                                  Discover
------------------------------------------------------------------------------->
broadcast 0.0.0.0 -> 255.255.255.255 ; UDP 68 -> 67 ; "Any DHCP server out there?"

                                  Offer
<-------------------------------------------------------------------------------
UDP 67 -> 68 ; "You can have 192.168.100.5 for 2 days"

                                  Request
------------------------------------------------------------------------------->
broadcast 0.0.0.0 -> 255.255.255.255 ; "Yes please that one" (other serrvers withdraw)

                                  Acknowledge
<--------------------------------------------------------------------------------
UDP 67 -> 68 ; "Confirmed it's yours"


Since the client has no IP address yet its ip address is seen as 0.0.0.0 (nobody) -> 255.255.255.255 (this is becasue client doesnt know where the server is yet so it shouts to everyone

### DHCP relay (DHCP helper)

Client                                Router                                   DHCP server
              Discover
-------------------------------------->
              Broadcast
                                                        Unicast
                                        -------------------------------------->
                                                    src = router IP

                                                         Offer
                                        <-------------------------------------- 
                                                        Unicast
                Offer
<---------------------------------------
              Broadcast
Broadcasts stop at routers, so a router configured as a relay forwards DHCP to a server on another subnet. Lets a company run central/backup DHCP servers.

### Configuring a DHCP serrver

Setting                |   Meaning
Scope                  |  The pool of addresses for one subnet (e.g. .10-.200)
Exclusion              |  Addresses in the pool never to hand out
Reservation            |  Same IP always given to one device, matched by its MAC (printers, servers)
Lease time             |  How long a device keeps the address
Options                |  Extra settings: 3 router, 6 DNS, 51 lease time, 129 VoIP server, 135 HTTP proxy

### Leases and renewal timers

8-day lease example. at T2 the client asks any DHCP server (rebinding). At day 8 the address goes back to the pool.
Day 0                                       Day 4 (T1)                                          Day 7 (T2)        Day 8
[---- 0-50% --- using the address ---------][---- T1-@-50% --- renew with SAME server ---------][-- T2 -@-87.5% --]

### Seen on my network
ipconfig /all :IP 192.168.100.5
mask 255.255.255.0 (/24)
DHCP server, gateway and DNS server all 192.168.100.1 (the router)
Lease ~ 2 days, to T1 ~ 1 day. No DHCP answer at all -> Windows self-assigns APIPA 169.254.x.x

--------------------------------------------------------------------------------------------------------------------------
Security angle:
DHCP has no authentication. A rogue DHCP server can hand out a fake gateway/DNS and sit in the middle of all traffic.
DHCP starvation uses up every address in the pool.
Defence: DHCP snooping  on switches.
--------------------------------------------------------------------------------------------------------------------------


## DNS records (UDP/TCP 53)


A DNS zone file is a list of resource records. Here are 8 to remember:

Record    |  Stands for                  |  Does                                                                  |  Example
SOA       |  Start of Authority          |  Top of the zone: domain, serial number, refresh/retry/expire timers   |  example.com zone header
A         |  Address                     |  Name -> IPv4                                                          |  example.com -> 172.66.147.243
AAAA      |  "Quad-A"                    |  Name -> IPv6 (4x longer address, 4 A's)                               |  example.com -> 2606:2700:10::6814:179a
CNAME     |  Canonical Name              |  Alias: name -> another name                                           |  www.example.com  ->  example.com
MX        |  Mail Exchanger              |  Which server recieves email (points to a name that needs A record)    |  gmail.com -> gmail-smtp-in.google.com
NS        |  Name Server                 |  Which servers are authoritative for the domain                        |  ns1/ns2.example.com
PTR       |  Pointer                     |  Reverse lookup: IP -> name (in-addr.arpa, IP backwards)               |  1.100.1668.192.in-addr.arpa
TXT       |  Text                        |  Free text: SPF, DKIM, domain verification                             |  v=spf1 include:...-all

Laptop                                                DNS server
              A record for www.example.com?
----------------------------------------------------------->

                CNAME -> mail.example.com
<-----------------------------------------------------------

              A record for mail.example.com?
----------------------------------------------------------->

                      IPv4 address
<-----------------------------------------------------------
CNAME = 2 lookups unless cached

### Email security (both are TXT records)
-  SPF (Sender Policy Framework): lost of servers allowed to send maul for the domain, used to spot spoofed email.
- DKIM (DomainKeys Identified Mail): a public key to check emails digital signature, proving it wasnt faked or changed.
TTL (Time To Live)
How many seconds an answer may be cached. Your example.com answer had TTL 183 s.

### Seen on my network
nslookup example.com -> laptop asked the router (192.168.100.1) over UDP 53
a PTR for the server itself ("No such name" which is normal). an A query -> 172.66.147.243 + 104.20.23.154 in ~9 ms, and an AAAA query -> two 2606:4700:... addresses.
Matching Transaction ID 0x0002 links question to answer.

-----------------------------------------------------------------------------------------------------------------------------------------------------
Security angle
Normal DNS is unencrypted: anyone on the network sees what you look up, and DNS spoofing/poisoning can send you to a fake site.
Defences: DNSSEC, DNS over HTTPS/TLS.
Attackers read MX/TXT/NS records for reconnaissance.
-----------------------------------------------------------------------------------------------------------------------------------------------------


## NAT and ICMP


NAT: Network Address Translation
Private addresses (10.x, 172.16-31.x, 192.168.x) cant travel on the internet. The router swaps your private IP:port for its one public IP and a port, and remembers the mapping so replies come back to you. 
Many devices sharing one public IP via ports = PAT (Port Address Translation), the normal setup.

Private                                                          Swaps the addresses                                                  Internet
My laptop       ---------------------------------------------->  Hoome router                  ------------------------------------>  Web server
192.168.100.5   <----------------------------------------------  192.168.100.1 <-> public IP   <------------------------------------  52.110.5.2
                          src 192.168.100.5:55825                                                src public-IP: 610012
                  The router remembers the mapping (NAT table), so the reply (bottom arrows) gets sent back to the right laptop.

## ICMP: Internet Control Message Protocol
Layer 3 "messages about the network". It has no ports.
Type  |  Message                        |  Used by
8/0   |  Echo request / echo reply      |  ping
11    |  Time exceeded (TTL hit 0)      |  tracert / traceroute
3     |  Destination unreachable        |  routers reporting failures

Other useful protocols
  - IPsec (IP Security): encrypts IP traffic, used for site-to-site VPNs (UDP 500/4500)
  - GRE (Generic Routing Encapsulation): a tunnel with no encryption, often combined with IPsec.
-------------------------------------------------------------------------------------------------------------------
Security angle
Many firewalls block ping, so "no reply" ≠ "host is down".
Attackers use ICMP sweeps to find live hosts and tracert to map a network.
-------------------------------------------------------------------------------------------------------------------


## HTTP and HTTPS


HTTP (HyperText Transfer Protocol) transfers web pages: TCP 80, plain text.
HTTPS = HTTP inside TLS: TCP 443, encrypted, and the certificate proves the server is genuine.

### Anatomy of a URL
 https :// user:pass @ tryhackme.com : 443  /view-room   ?id=1    #task3
|_____|   |_________| |_____________| |___| |_________| |_____|  |______|
scheme       user           host      port     path      query   fragment

### Request and response

Browser -> Server (Request)
GET /index.html HTTP/1.1
Host: tryhackme.com
User-Agent: Firefox
Cookie: session=abc
(blank line)

Server -> Browser (Response)
HTTP/1.1 200 OK
Server: nginx
Content-Type: text/html
Set-Cookie: session=abc
(blank line)
<html> ... <html>

Method                  |  Does
GET                     |  Fetch a page/data
POST                    |  Send data, create something (login, form)
PUT                     |  Update existing data
DELETE                  |  Remove data

Code                    |  Meaning
2xxx                    |  200 OK; 201 Created
3xx                     |  301 Moved Permanently; 302 Found (temporary)
4xx client              |  400 Bad Request; 401 Unauthorised; 403 Forbidden; 404 Not Found; 405 Method Not Allowed
5xx                     |  500 Internal Server Error; 503 Service Unavailable

Request headers           |  Responsible headers
Host: which site          |  Server: web server software
User-Agent: browser       |  Content-Type: HTML, image....
Cookie: saved cookies     |  Set-Cookie: store this
Accept-Encoding: gzip OK? |  Cache-Control: how long to cache

### Cookies

HTTP is stateless (it forgets you). The server sends Set-Cookie, and the browser send it back in Cookie on every request. 
Used for logins (session tokens), settings and tracking. See them in Dev Tools (F12) -> Network
---------------------------------------------------------------------------------------------------------------------------
Security angle
Steal a session cookie and you can log in as that person (session hijacking). That's why HTTPS and the Secure / HttpOnly cookie flags matter.


## TLS: what HTTPS hides (and what it doesn't)


Browser                                                                                                      Server
                                              TCP:SYN->SYN/ACK->ACK
       ----------------------------------------------------------------------------------------------------->
                                                connection first

                                              TLS Client Hello
       ----------------------------------------------------------------------------------------------------->
                              supported ciphers + SNI = site name (in dear text)

                                            Server Hello + Certificate
       <-----------------------------------------------------------------------------------------------------
                                      chosen cipher + proof of identity

                                      Key exchange -> shared secret
       ----------------------------------------------------------------------------------------------------->
                                      both sides now have the same key

                                      Application Data (encrypted)
       _____________________________________________________________________________________________________>
                                    HTTP inside, unreadable to anyone watching

Still visible to someone watching the network                                  |  Hidden by HTTPS
Your IP and the server's IP; ports (443); timing and size of traffic           |  The page content, URL path and query string
The DNS lookup for the site (unless DNS is encrypted)                          |  Usernames, passwords, cookies, from data
The SNI (site name) in the Client Hello                                        |  HTTP headers ( Host, User-Agent, Cookie...)

Seen on my network
Packets 38364-38366: TCP handshake laptop -> Microsoft 52.110.5.2:443 (flags 0x002 SYN, 0x012 SYN-ACK, then ACK). 
Packet 38367: TLS Client Hellop with SNI = officeclient.microsoft.com, then Server Hello, then only "Application Data".


## A web request, end to end


What happens between turning the laptop on and a page appearing:

  1. DHCP - get IP, gateway, DNS UDP 67/68
  2. ARP  - find router's MAC L2 broadcast
  3. DNS  - name -> IP UDP53
  4. TCP  - SYN,SYN/ACK,ACK port 443
  5. TLS  - Client Hellop (SNI) ... keys agreed
  6. HTTP - GET -> 200 OK inside TLS
  7. NAT  - router swaps private <-> public

Step    |  Protocol  |  OSI layer  |  Port        |  In one sentence
  1     |  DHCP      |      7      |  UDP 67/68   |  The router giver the laptop 192.168.100.5, gateway and DNS server
  2     |  ARP       |      2      |  -           |  Laptop learns the routers MAC so it can send frames to it
  3     |  DNS       |      7      |  UDP 53      |  Router answers "bbc.co.uk is at ..."
  4     |  TCP       |      4      |  443         |  3-way handshake opens a reliable connection
  5     |  TLS       |     6/7     |  443         |  Encryption is agreed; the site name leaks in the SNI
  6     |  HTTP      |      7      |  443 (in TLS)|  GET/, then 200 OK and the HTML; the browser renders the page
  7     |  NAT       |      3      |  -           |  On every packet out, the router swaps the private source for its public IP


## Wireshark skills


The window
Pane                        |  Shows
Packet list (top)           |  One row per packet: No., Time, Source, Destination, Protocol, Info
Details (bottom-left)       |  The selelcted packet layer by layer: Frame -> Ethernet -> IP -> TCP/UDP -> app
Bytes  (bottom-right)       |  Raw hex. Contains MACs, so crop it from screenshots

Handy features
  - Follow -> TCP Stream: the whole conversation (red = client, blue = server)
  - Statistics -> Protocol Hierarchy: % of each protocol
  - Statistics -> Conversations: who talked to whom
  - Click the No. header to sort back into time order

Filter                                     |  Shows
dhcp                                       |  DORA messages (bootp on old versions)
arp                                        |  ARP requests + replies
dns                                        |  DNS queries + responses
dns.flags.response == 1                    |  DNS answers only
dns.qry.name == "example.com"              |  One name only
tcp.flags.syn == 1 && tcp.flags.ack == 0   |  Only the first SYN of each handshake
tcp.stream eq 60                           |  One TCP conversation
http                                       |  Plain-text web traffic
tls.handshake.type == 1                    |  TLS Client Hellos (see SNI)
ip.addr == 192.168.100.5                   |  Everything to/from one host

tcp.flags.syn  on its own matches every TCP packet (the field exists). Always add == 1.


Commands I used (and the Kali versions)

Windows                                      |  Kali/Linux                                                |  What it does
ipconfig /all                                |  ip a  ;  ip route                                         |  Full network config: IP, mask, gateway, DHCP, DNS
ipconfig /release + /renew                   |  nmcli con down "WiFi-name" + nmcli con up "Wifi-name"     |  Drop and re-request a DHCP lease (generates DORA)
ipconfig /flushdns (Admin)                   |  usually nothing to flush (no local DNS cache by default)  |  Clear cached DNS answers
nslookup example.com                         |  dig example.com                                           |  DNS lookup (A/AAAA)
nslookup -type=mx gmail.com                  |  dig mx gmail.com                                          |  Look up a specific record type
arp -a ; arp -d ; (Admin)                    |  ip neigh                                                  |  Show / clear the ARP cache
ping 8.8.8.8                                 |  ping -c 4 8.8.8.8                                         |  ICMP echo, "can I reach it?"
tracert bbc.co.uk                            |  traceroute bbc.co.uk                                      |  Every router hop on the way


