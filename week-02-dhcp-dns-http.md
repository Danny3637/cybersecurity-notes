Week 02 DHCP, DNS & HTTP
Sources:
  1. Professor Messer N10-009
    1.1 Network Communication
    1.2 DHCP
    1.3 Configuring DHCP
    1.4 DNS Records
  2. TryHackMe
    2.1 HTTP in Detail (evidence: session1-terminal-notes, capture-notes

The big picture: when my laptop joins Wi-Fi and opens a website, these happen in order:
DHCP (get an IP address) -> DNS (name -> IP) -> TCP + TLS (connect securely) -> HTTP(S) (request the page)


                                                                                    1. Network communication: the 4 ways to send data

Type      |  Who receives it                                |  Example                                               |  IPv4  |  IPv6  
Unicast   |  One specific device (one-to-one)               |  Loading a website, email, file transfer               |  YES   |  YES   
Multicast |  Many devices that subscribed (one-to-many)     |  Video streaming, stock-market feeds, routing updates  |  YES   |  YES   
Anycast   |  The closest one of a group sharing one IP      |  Anycast DNS (query goes to nearest data centre)       |  YES   |  YES   
Broadcast |  Every device on the local network (one-to-all) |  ARP requests, DHCP Discover                           |  YES   |  NO (IPv6 uses multicast instead)  

<img width="935" height="195" alt="Screenshot 2026-10-26 211511" src="https://github.com/user-attachments/assets/8edc8e9e-e4a2-4f26-8c36-4141417cbb44" />

Key points
- Unicast to many people = a separate copy for each person, which is wasteful
- Multicast needs network equipment that supports it, so its mostly used inside the organisation, not across the internet.
- Broadcasts never leave the local network: routers don't forward them. (Thats why DHCP needs a relay, see 2.3)
----------------------------------------------------------------------------------------------------------------------------------
Security Angle
A broadcast reaches everyone on the LAN, so anyone listening can see it. That's how I saw other devices' ARP requests in Wireshark.
----------------------------------------------------------------------------------------------------------------------------------

                                                                                        2. DHCP: Dynamic Host Configuration Protocol

Job: automatically give a device its IP address, subnet mask, default gateway and DNS server, so nobody has to type them in by hand.
History: BOOTP came first, but it couldnt do everything (e.g. take addresses back when devices left). DHCP replaced it.
Ports:
  1. UDP 67 = server
  2. UDP 68 = client.

2.1 DORA: how a device gets an address

Client (no IP yet)                                                                              DHCP server
                                                1 - Discover
                   ---------------------------------------------------------------------------->
                  broadcast 0.0.0.0 -> 255.255.255.255, UDP 68 -> 67, "Any DHCP server out there?"

                                                2 - Offer
                   <----------------------------------------------------------------------------
                  broadcast, UDP 67 -> 68, "You can have 192.168.100.5"

                                                3 - Request
                  ------------------------------------------------------------------------------>
                  broadcast 0.0.0.0 -> 255.255.255.255, UDP 68 -> 67, "Yes please, that one"

                                                4 - Acknowledge                
                  <------------------------------------------------------------------------------
                  UDP 67 -> 68, "Confirmed, it's yours for the lease time"

Easy way to remember: D-O-R-A = Don't Own Real Address (yet)

2.2 DHCP relay (DHCP helper)
Broadcasts stop at the router, so a DHCP server in another subnet can't hear a Discover.
Fix: the router acts as a relay.

Client subnet A                                  Router + DHCP relay                                      DHCP server (subnet B)
                          Discover
                -------------------------------->
                broadcast
                                                                          Discover -> UNICAST
                                                                      ----------------------------------->
                                                                      source = router's IP

                                                                                  Offer
                                                                      <-----------------------------------
                                                                      unicast back to router
                           Offer
                <--------------------------------
                broadcast onto subnet A

* Request and Acknowledge are relayed the same way

- The client never knows the server is somewhere else.
- Lets a company run central or backup DHCP servers for many sites.

2.3 Configuring DHCP

Setting        |  What it is                                                                                                          |  Example
Scope          |  The range (pool) of addresses the server can hand out for one subnet                                                |  192.168.1.10 - 192.168.1.200
Exclusion      |  Addresses inside the scope that must never be handed out                                                            |  192.168.1.50 (used by a server set manually)
Revervation    |  A fixed IP always given to one device, matched by its MAC address (also called " static DHCP "/" IP reservation ")  |  printer always gets 192.168.1.6
Lease duration |  How long a device may keep its address                                                                              |  8 days
Options        |  Extra settings sent with the address. 254 are available (BOOTP called them "vendor extensions")                     |  subnet mask, gateway, DNS server, option 129 VoIP call server, option 135                                                                                                                                           HTTP proxy
Why reservations instead of typing a static IP into the printer?
  To manage everything centrally in one place, and changes are easy.

Leases & renewal timers
[---- 0 - 50% using the address -----] [------- T1 @ 50% renew with SAME server --------] [----- T2 @ 87.5% -----]
Day 0                              Day 4 (T1)                                        Day 7 (T2)                 Day 8

8 day lease example.
At T2 the client asks any DHCP server (rebinding).
At day 8 the lease expires and then address goes back to the pool.

- T1 = 50% of the lease: the client asks its original server to renew
- T2 = 87.5% (7/8): if the original server hasn't answered, it asks any DHCP server.
- Lease runs out with no renewal: the address goes back to the pool.
- If no DHCP server answers at all, Windows gives itself an APIPA address (169.254.x.x), which is a sign DHCP failed.

In my house (from ipconfig /all): DHCP server = router 192.168.100.1, IP 192.168.100.5/24, lease ~ 2 days so T1 = 1 day
------------------------------------------------------------------------------------------------------------------------
Security angle:
DHCP has no authentication. A rogue DHCP server could hand out a fake gateway/DNS and sit in the middle of all traffic. A DHCP starvation attack uses up the whole pool. 
Defence: DHCP snooping on switches.
-------------------------------------------------------------------------------------------------------------------------

                                                                                        3. DNS records: Domain Name System

DNS turns names into IP addresses (UDP/TCP 53). A DNS server's zone/configuration file is made of lines called resource records.

Record    |  Stands for            |  What it does                                                                                      |  Example
SOA       |  Start of Authority    |  Top of the zone file: which doain, serial number, refresh/retry/expire timers, how long to cache  |  example.com zone summary
A         |  Address               |  Name -> IPv4 address (the most common lookup)                                                     |  example.com -> 172.66.147.243
AAAA      |  Quad - A              |  Name -> IPv6 address (4 A's because IPv6 is 4x longer)                                            |  example.com -> 2606:4700:10::6814:179a
CNAME     |  Canonical Name        |  Alias: points one name at another name                                                            |  www.example.com -> mail.example.com
MX        |  Mail Exchanger        |  Which server recieves email for the domain (points to a name, which needs its own A record)       |  gmail.com -> gmail-smtp-in.I.google.com
NS        |  Name Server           |  Whcih servers are authoritative for the domain                                                    |  ns1 / ns2.example.com
PTR       |  Pointer               |  Reverse lookup: IP -> name (IP written backwards in in-addr.arpa                                  |  15.23.168.192.in-addr.arpa -> www.example.com
TXT       |  Text                  |  Free text, used for SPF, DKIM and domain veriication                                              |  v=spf1 include:... -all

3.1 How a CNAME lookup works

My laptop                                                            DNS Server
              A record for 222.example.com?
          ---------------------------------------------------------->

              CNAME -> mail.example.com
          <----------------------------------------------------------

              A record for mail.example.com?
          ----------------------------------------------------------->

              93.184.216.34
          <-----------------------------------------------------------

2 lookups, unless the answer is already  cached

Email security records (both live in TXT records)
- SPF (Sender Policy Framework(: a list of which mail server are allowed to send email for the domain. Receiving server check it to spot spoofed email.
- DKIM (DomainKeys Identified Mail): a public key used to check the digital signature on outgoing email, providing it really came from the domain and wasn't changed.

3.2 TTL: Time To Live
How long (in seconds) an answer may be cached before asking again. My example.com answer had TTL 183s (~3 min)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Security angle:
normal DNS is unencrypted, so anyone on the network can see what I look up, and DNS spoofing/poisoning can send me to a fake site. 
Defences:
  - DNSSEC
  - DNS over HTTPS/TLS
Attackers also use TXT/MX lookups for reconnaissance.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
My network:
My DNS server is the router 192.168.100.1. In Wireshark: PTR 1.100.168.192.in-addr.arpa -> "No such name" (normal), A example.com -> 2 IPv4 addresses.


                                                                            4. HTTP & HTTPS: HyperText Transfer Protocol

- HTTP = the rules browsers and web servers use to transfer web content (HTML, images, video). Port 80, readable by anyone.
- HTTPS = HTTP over TLS. Traffic is encrypted, and the certificate proves you're talking to the real server. Port 443

4.1 Anatomy of a URL (Uniform Resource Locator)

