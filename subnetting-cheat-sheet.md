SUBNETTING CHEAT SHEET
> Week 01 deliverable · [[Week 01]] · [[Roadmap]]
> Covers: CIDR table · special ranges · magic number method · 3 worked examples · common ports

                                                                                            1. Basics:
                                                                                        
An IPv4 address is 32 bits, written as 4 octets of 8 bits. The /Prefix dictates how many bits from the left are the network part. The rest bits are reserved for the host.
Example:
IP address:         192      .    168     .    10      .    77
Binary:    11000000  .  10101000  .  00001010  .  01001101
         |_____________ /27 = 27 network bits ____________||_5 host bits_|
Host bits = 32 - prefix. Usable hosts = 2^(host bits) - 2.
The (-2) is because the first address is the network ID and last is the broadcast. Neither one of those goes on a device.

Network, subnet and host bits.
Start from a normal /24 network. Every extra mask bit you add is a subnet bit (borrowed fromt he host part).
Example:
IP address:     192.168.1.0       = 11000000.10101000.00000001.00000000
Subnet Mask:    255.255.255.192   = 11111111.11111111.11111111.11000000
|________Network = 24 bits________|  |____S = 2____|  |____Host = 6____|
Total subnets: 2^(subnet bits) = 2^2 = 4
Hosts per subnet: 2^(host bits)-2 = 2^6-2 = 64-2 = 62

                                                                                          2. CIDR table: /24 to /30
                                                                  
CIDR  |  Subnet mask    |  Last octet (binary)  |  Block size (Magic Number)  |  Total addresses  |  Usable hosts  |  Subnets per /24
/24   |  255.255.255.0  |  0000 0000            |              256            |        256        |       254      |          1
/25   | 255.255.255.128 |  1000 0000            |              128            |        128        |       126      |          2
/26   | 255.255.255.192 |  1100 0000            |              64             |        64         |       62       |          4
/27   | 255.255.255.224 |  1110 0000            |              32             |        32         |       30       |          8
/28   | 255.255.255.240 |  1111 0000            |              16             |        16         |       14       |          16
/29   | 255.255.255.248 |  1111 1000            |              8              |        8          |       6        |          32
/30   | 255.255.255.252 |  1111 1100            |              4              |        4          |       2        |          64

Patterns to memorise:
- Each +1 on the prefix halves the block and doubles the subnets.
- Block size x subnets per /24 = 256 always.
- Mask Values: 128 . 192 . 224 . 240 . 248 . 252 . 254 . 255
- /30 = 2 hosts: the classic router-to-router link.
Mask octet in binary  |  Decimal
      0000 0000       |    0
      1000 0000       |    128
      1100 0000       |    192
      1110 0000       |    224
      1111 0000       |    240
      1111 1000       |    248
      1111 1100       |    252
      1111 1110       |    254
      1111 1111       |    255

Powers of 2
2^8  |  2^7  |  2^6  |  2^5  |  2^4  |  2^3  |  2^2  |  2^1
256  |  128  |  64   |  32   |  16   |  8    |  4    |  2

2^16    |  2^15    |  2^14    |  2^13   |  2^12   |  2^11   |  2^10   |  2^9
65,536  |  32,768  |  16,384  |  8,192  |  4,096  |  2,048  |  1,024  |  512

                                                                                  3. All prefixes at a glance ( /1 to /32 )
                                                                    
Find your prefix in one of the 4 columns. The column tells you the interesting octet. The row gives you the mask value in that octet, how many networks it splits that octet into and the block size (addresses per network)

Octet 1  |  Octet 2  |  Octet 3  |  Octet 4  | Mask Value  |  Networks  |  Addresses (block size)
  /1     |    /9     |    /17    |    /25    |    128      |      2     |        128
  /2     |    /10    |    /18    |    /26    |    192      |      4     |        64
  /3     |    /11    |    /19    |    /27    |    224      |      8     |        32
  /4     |    /12    |    /20    |    /28    |    240      |      16    |        16
  /5     |    /13    |    /21    |    /29    |    248      |      32    |        8
  /6     |    /14    |    /22    |    /30    |    252      |      64    |        4
  /7     |    /15    |    /23    |    /31    |    254      |      128   |        2
  /8     |    /16    |    /24    |    /32    |    255      |      256   |        1

Example:
/11 is in the Octet 2 column, row 3-> mask 255.224.0.0, block size 32 in the 2nd Octet.
/31 and /32 are special: 
  /31 is used for router-to-router links (2 addresses, no network/broadcast)
  /32 is a single host

Block size chart: where every subnet starts
Pick the row for your block size (magic number), then find the cell your IP's octet falls in. The number in that cell is the NEtwork ID; the next cell's number -1 is the broadcast.
0-127
128  |0
64   |0                                                             |64
32   |0                             |32                             |64                             |96
16   |0             |16             |32             |48             |64             |80             |96                |112
8    |0      |8     |16     |24     |32     |40     |48     |56     |64     |72     |80     |88     |96      |104      |112      |120
4    |0  |4  |8 |12 |16 |20 |24 |28 |32 |36 |40 |44 |48 |52 |56 |60 |64 |68 |72 |76 |80 |84 |88 |92 |96 |100 |104 |108 |112 |116 |120 |124

128 - 255
128  |128
64   |128                                                                              |192
32   |128                                      |160                                    |192                                    |224
16   |128                  |144                |160                |176                |192                |208                |224                |240
8    |128        |136      |144      |152      |160      |168      |176      |184      |192      |200      |208      |216      |224      |232      |240      |248
4    |128  |132  |136 |140 |144 |148 |152 |156 |160 |164 |168 |172 |176 |180 |184 |188 |192 |196 |200 |204 |208 |212 |216 |220 |224 |228 |232 |236 |240 |244 |248 |252

                                                                                            4. Special address ranges
                                                                            
   Type            |              Range              |        CIDR        |        What's it for
Private (Class A)  |  10.0.0.0 - 10.255.255.255      |    10.0.0.0/8      |   Large company networks
Private (Class B)  |  172.16.0.0 - 172.31.255.255    |    172.16.0.0/12   |   Medium networks (only 16 to 31)
Private (Class C)  |  192.168.0.0 - 192.168.255.255  |    192.168.0.0/16  |   Home and small office networks
Loopback           |  127.0.0.0 - 127.255.255.255    |    127.0.0.0/8     |   The machine talking to itself (127.0.0.1 = localhost)
APIPA / link-local |  169.254.0.0 - 169.254.255.255  |    169.254.0.0/16  |   Self-assigned when DHCP fails

Quick ID: "What kind of address is this?"
10.x * 172.16-31.x * 192.168.x    =    Private. Internal only, reaches the internet through NAT.
127.x.x.x                         =    Loopback. Never leaves the machine
169.254.x.x                       =    APIPA. DCHP failed: check cable, Wi-Fi, VLAN, DHCP server.
Anything else                     =    Public. Routable on the internet.
Watch out:
172.15.x.x and 172.32.x.x are public. Aworking ping 127.0.0.1 only proves the machine's own TCP/IP stack works, nothing beyond it.

                                                                                    5. The magic number method, step by step

Finds the network ID, broadcasts, first/last host and host count for any IP/prefix, inyour head.
5.1 Find the interesting octet:
  The one where the mask isn't 255 or 0.
    - /8-/15  -> 2nd Octet
    - /16-/23 -> 3rd Octet
    - /24-/30 -> 4th Octet
5.2 Get the mask value in that octet (128,192,224,240,248,252,254).
5.3 Magic number = 256 -mask value. This is the block size.
  Shortcut:
    2^(8-(prefix mod 8)). 
    For /27: 27 mod 8 = 3 -> 2^5 = 32
5.4 Count up in multiples of the magic number: 0, M, 2M, 3M ...
5.5 Network ID = The biggest multiple that's ≤ the IP's value in tht octet. Octets after it -> 0
5.6 Broadcast = next multiple -1, Octets after it -> 255
5.7 Fist host = network +1
    Last host = broadcast -1
    Usable hosts = 2^(32-prefix)-2

--------------------------------------------------------------------------
Rule of thumb:
Octets before the interesting octet never change: copy them straight fromt he IP.
--------------------------------------------------------------------------

Interesting octet -> magic number -> mask

Prefix if interesting octet = 2    |  /9  |  /10  |  /11  |  /12  |  /13  |  /14  |  /15  |  /16  |           
Prefix if interesting octet = 3    |  /17 |  /18  |  /19  |  /20  |  /21  |  /22  |  /23  |  /24  |                      
Prefix if interesting octet = 4    |  /25 |  /26  |  /27  |  /28  |  /29  |  /30  |   -   |   -   |               
Magic number (block size)          |  128 |   64  |   32  |   16  |   8   |   4   |   2   |   1   |                
Mask value in that octet           |  128 |  192  |  224  |  240  |  248  |  252  |  254  |  255  |                   

Example:
/22 = octet 3 row
  6th column =magic number 4
    mask value 252 = 255.255.252.0.

                                                                                                      6. Worked examples

Example 1:
|             192.168.10.77/27                |
-----------------------------------------------                
        Step          |          Working
-----------------------------------------------
Interesting octet     |    /27 = 4th octet (value 77)
Mask                  |    255.255.255.224
Magic number          |    256 - 224 = 32
Multiples             |    0, 32, 64, 96, 128 ... -> 77 sits between 64 and 96
Host bits             |    32 - 27 = 5-> 2^5 - 2 = 30 hosts

                                                  .77       .95bc
                                           -------------------------
|-------------------|---------------------|       *                 |-------------------------|
                                           -------------------------
.0                 .32                 .64 net                     .96                        .128

Networkk ID:         192.168.10.64
Usable Range (30):   .65 - .94
Broadcast:           192.168.10.95
Binary check:
  77 = 010 01101 And 224 = 111 00000 -> 010 00000 = 64


Example 2: 
|             172.16.5.200/28                 |
-----------------------------------------------                
        Step          |          Working
-----------------------------------------------
Interesting octet     |    /28 = 4th octet (value 200)
Mask                  |    255.255.255.240
Magic number          |    256 - 240 = 16
Multiples             |    ... 160, 176, 192, 208, 224 ... -> 200 sits between 192 and 208
Host bits             |    32 - 28 = 4-> 2^4 - 2 = 14 hosts

                                                     .200     .207bc
                                         -------------------------
------------------|---------------------|             *           |-------------------------|
                                         -------------------------
                 .176                 .192 net                   .208                     .224

Networkk ID:         172.16.5.192
Usable Range (14):   .193 - .206
Broadcast:           172.16.5.207
Binary check: 
  200 = 1100 1000 and 240 = 1111 0000 -> 1100 0000 = 192

Example 3: 
|              10.20.77.15/22                 |
-----------------------------------------------                
        Step          |          Working
-----------------------------------------------
Interesting octet     |    /22 = 3rd octet (value 77)
Mask                  |    255.255.252.0
Magic number          |    256 - 252 = 4
Multiples             |    ... 68, 72, 76, 80, 84 ... -> 77 sits between 76 and 80
Host bits             |    32 - 22 = 10-> 2^10 - 2 = 1,022 hosts

                                          10.20.77.15        .79.255bc
                                         -------------------------
------------------|---------------------|      *                  |-------------------------|
                                         -------------------------
              10.20.72.0            10.20.76.0 net         10.20.80.0                 10.20.84.0

Networkk ID:            10.20.76.0
Usable Range (1,022):   .76.1 - .79.254
Broadcast:              10.20.79.255
Binary check: 
  77 = 010011 01 and 252 = 111111 00 -> 010011 00 = 76
  
------------------------------------------------------------------------------------
Common mistakes
-  Forgetting the -2 (a /27 has 32 addresses but only 30 hosts)
-  Using the next multiple as the broadcast instead of the next multiple -1.
-  On /16-/23, forgetting to set the 4th octet to .0 (network) and .255 (broadcast).
-  Thinming 172.32.x.x is private. Private is only 172.16 to 172.31.
------------------------------------------------------------------------------------

                                                                                                      7. Common Ports

Port      |    Protocol    |    TCP/UDP    |                What it does                                           |      Secure?    
20/21     |    FTP         |    TCP        |   File transfer (20 data, 21 control)                                 |  No, cleartext
22        |SSH / SFTP /SCP |    TCP        |   Encrypted remote shell and file transfer                            |  Yes
23        |    Telnet      |    TCP        |   Remote shell (replace with SSH)                                     |  No, cleartext
25        |    SMTP        |    TCP        |   Email between mail servers                                          |  No (unless STARTTLS)
53        |    DNS         |    UDP + TCP  |   NName -> IP lookups (TCP for zone transfers / big replies)          |  No
67/68     |    DHCP        |    UDP        |   Hands out IP addresses (67 server, 68 client)                       |  No
69        |    TFTP        |    UDP        |   Simple file transfer, no log in                                     |  No
80        |    HTTP        |    TCP        |   Web                                                                 |  No
110       |    POP3        |    TCP        |   Download email                                                      |  No
123       |    NTP         |    UDP        |   Time sync                                                           |  No
137-139   |    NetBIOS     |    TCP/UDP    |   Old Windows naming / file sharing                                   |  No
143       |    IMAP        |    TCP        |   Read email on the server                                            |  No
161/162   |    SNMP        |    UDP        |   Device monitoring (162 = traps)                                     |  v1/v2c no * v3 yes
389       |    LDAP        |    TCP        |   Directory lookups (Active Directory)                                |  No
443       |    HTTPS       |    TCP        |   Web over TLS                                                        |  Yes
445       |    SMB         |    TCP        |   Windows file sharing                                                |  Never expose to internet
465/587   |SMTPS/Submission|    TCP        |   Sending email securely                                              |  Yes
636       |    LDAPS       |    TCP        |   LDAP over TLS                                                       |  Yes
993       |    IMAPS       |    TCP        |   IMAP over TLS                                                       |  Yes
995       |    POP3S       |    TCP        |   POP3 over TLS                                                       |  Yes
1433      |    MS SQL      |    TCP        |   Miscrosoft SQL Server                                               |  Keep internal
3306      |    MySQL       |    TCP        |   MySQL / MariaDB                                                     |  Keep internal
3389      |    RDP         |    TCP        |   Windows Remote Desktop                                              |  Big attack target
5060/5061 |    SIP         |    TCP/UDP    |   VoIP calls (5061 = TLS)                                             |  5060 no * 5061 yes

Memory tricks
- Secure version = different port:
    80  -> 443
    389 -> 636
    143 -> 993
    110 -> 995
- Ports:
  - 0 - 1023 well-known
  - 1024 - 49151 registered
  - 49152 - 65535 dynamic (client side)

TCP vs UDP
TCP
  - Reliable
  - Handshake first:
      SYN -> SYN -> ACK -> ACK
  - Web
  - SSH
  - Email
  - File sharing
UDP
  - Fast
  - No handshake
  - DNS queries
  - DHCP
  - NTP
  - SNMP
  - TFTP
  - Streaming

8. Practice
