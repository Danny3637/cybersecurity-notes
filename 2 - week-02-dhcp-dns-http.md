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

