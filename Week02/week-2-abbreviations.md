# Week 2 Abbreviations

Abbreviation  |                         Stands For                          |                  What it means
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AAAA          |      "Quad-A" Record                                                |  Name -> IPv6 address
A             |      Address record                                                 |  Name -> IPv4 address
APIPA         |      Automatic Private IP Addressing                                |  169.254.x.x self-assigned address when DHCP fais
ARP           |      Address Resolution Protocol                                    |  Finds the MAC address for an IP on the LAN (uses broadcast)
BOOTP         |      Bootstrap Protocol                                             |  Older protocol DHCP replaced
CNAME         |      Canonical Name                                                 |  Alias pointing one name to another name
DHCP          |      Dynamic Host Configuration Protocol                            |  Hands out IP settings automatically (UDP 67/68)
DKIM          |      DomainKeys Identified Mail                                     |  Public key in DNS that verifies email signatures
DMARC         |      Domain-based Message Authentication, Reporting & Conformance   |  Email policy that builds on SPF/DKIM (next step, not covered in these videos)
DNS           |      Domain Name System                                             |  Turns names (google.com) into IP addresses (UDP/TCP 53)
DNSSEC        |      DNS Security Extensions                                        |  Digitally signs DNS answers to stop spoofing
DORA          |      Discover, Offer, Request, Acknowledge                          |  The 4 DHCP steps
FTP           |      File Transfer Protocol                                         |  Old unencrypted file transfer  (TCP 20/21)
HTML          |      HyperText Markup Language                                      |  The language web pages are written in
HTTP          |      HyperText Transfer Protocol                                    |  Web protocol, unencrypted (TCP 80)
HTTPS         |      HTTP Secure                                                    |  HTTP over TLS (TCP 443)
IP            |      Internet Protocol                                              |  Addressing and routing of packets
IPv4/IPv6     |      Internet protocol version 4/6                                  |  32-bit / 128-bit addresses

Abbriveation  |      Stands for                                             |  Meaning
LAN           |      Local Area Network                                     |  Network in one place
MAC           |      Media Access Control (address)                         |  Hardware address of a network card, used by DHCP reservation
MX            |      Mail Exchange                                          |  DNS record: domain's email server
NS            |      Name Server                                            |  DNS record: authoritative servers for a domain
PTR           |      Pointer                                                |  DNS record: reverse lookup IP -> name
RFC           |      Request for Comments                                   |  Official documents that define internet standards (e.g. DHCP options)
SOA           |      Start of Authority                                     |  First record in a DNS zone: zone summary + timers
SPF           |      Sender Policy Framework                                |  TXT record listing allowed email senders
SNI           |      Server Name Indication                                 |  Website name sent in the TLS Client Hello (visiible even with HTTPS)
TLS           |      Transport Layer Security                               |  Encryption used by HTTPS
TTL           |      Time To Live                                           |  How long a DNS answer can be cached
TXT           |      Text record                                            |  DNS record holding free text (SPF, DKIM)
UDP           |      User Datagram Protocol                                 |  Fast, connectionless transport (DHCP, DNS)
URL           |      Uniform Resource Locator                               |  A web address
VoIP          |      Voice over IP                                          |  Phone calls over the network (DHCP option 129)
