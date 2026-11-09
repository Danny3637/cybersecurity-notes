# Firewall Types

## The universal security control

- Standard issue
	- Home, Office, and in your operating system
- Control the flow of the network traffic
	- Everything passess through the firewall
- Corporate control of outbound and inbound data
	- Sensitive materials
- Control of inappropriate content
	- Not safe for work, parental control
- Protection against evil
	- Anti-virus, anti-malware

## Network Based Firewalls

- Traditional network -based firewalls can controll traffic based on OSI layer 4
	- So, that would be:
		- TCP port
		- UDP port number
- More modern, next-generation firewalls are absle to manage traffic based on OSI layer 7 (Application)
	- So, they are able to:
		- Allow or disallow traffic based on what application is being used over the network.
- Appart from controling traffic flows firewalls can also:
	- Integrate other services inside of the firewall such as a Virtual Private Netwrok (VPN)
	- Many firewalls can also operate as layer 3 device or a router
		- These devices would commonly ist ont he endge of the network and controll the traffic flows between the internal network and the external network
		- As a result of providing layer 3 functionallity, these firewalls can provide netwrok address translation and other types of routing protocols.

## UTM / All-in-one security appliance

- Some older firewalls provide a number of different features bundled within one device called:
	- Unified Threat MAnagement (UTM) device.
		- Sometimes reffered to as Web Security Gateway/All-in-one security appliance
			- They are reffered to as all-in-one because they can handle many different services at the same time
- URL filtering or content inspection can allow or disallow access to certain websites
- These UTM can also have some capabillity of identifying malware and blocking it before it gets into your network.
- Many UTMs can also be used to filter spam  or blocking unwanted email correspondence within the firewall itself.
- These devices can also provide additional functionality for WAN connectivity such as  CSU/DSU or routing and switching built into the device itself.
- Also firewall functionality itself is included along with the abillity to block malicious software through the use of an IDS or IPS.
- Since all the traffic is flowing through this device it can also be used as a bandwidth shaper to provide quality of service across different applciations or protocols.
- In many cases these UTMs can also act as a VPN concentrator or VPN endpoint providing a way for people to connect securely to the corporate enviroment
- One of the challenges with UTMs is that many of thesse devices only operate at layer 4 so they only look at port numbers
- Having all of those capabillities within a one single device often provides a drawback to performance.
	- so turning on a few of these capabillities can result in the whole device slowing down

## Next-generation firewall (NGFW)

- These devices operate at OSI layer 7
- These devices can make forwarding decisions based on the applciations that are being used ont he network
- Sometimes NGFW is described as application layer gateway, stateful multilayer inspection devices, or deep packet inspection
- The NGFW is able to examine all traffic traversing the network and perform a full packet decode of everything traversing those links.
	- Meaning the firewall can:
		- Recognise whos sneding the traffic
		- Where the traffic goes
		- What is contained within the application layer of the traffic
		- Make forwarding decisions on whether that traffic is allowed or disallowed through the firewall.
Example:
- For example a next gen firewall might allow Microsoft SQL Server traffic to go through the firewall regardless of what port it is using.
- Maybe it will allow people to view twitter posts but not post themselves on twitter
- Or you can restrict people from watching Youtube videos
it is very possible that all of these applications are using simmilar port numbers but because this firewall operates on an application level it doesnt just rely on a port number to make a forwarding decision.

- It is also very common for NGFW to have a list of known vulnerabillities that it can allow or block in the firewall itself. Turning it into an intrusion prevention system
- Many NGFW will also include categorization of URLs so you can allow or block traffic to a specific type of website or a specific URL itself.
- So it is possible ot configure rules inside a NGFW that would prohibit anyone on that network from vising a gambling website.
- Or URLS can be individually listed.

## Web Application Firewall (WAF)

-WAFs are designed to analyze input into web-based applications and aither allow or disallow that traffic based on what the input happens to be.
	- This is very common for web-based conversations using HTTP or HTTPS
- WAF and NGFW can be used simoultaneously as both of them are looking at different traffic and making different forwarding decisions.

## Firewall rules

- It follows a logila path from top to bottom
- Can be very general or very specific (specific rules are usually at the top)
- Implicit deny
	- Most firewalls include a deny at the bottom (even if you didnt put one)
- Access Control Lists (ACLs)
	- Allow or disallow traffic
	- Grouping of categories:
		- Source IP
		- Destination IP
		- Port number
		- Time of day
		- Application Name etc.

## Web server firewall rules

| Rule Number | Remote IP | Remote Port | Local Port | Protocol | Action |
|---|---|---|---|---|---|
| 1 | Will accept All traffic | Any | its looking for any traffic destined for port 22 | as long as set traffic uses TCP protocol | Allow |
| 2 | All | Any | 80 | TCP| Allow |
| 3 | All | Any | 443 | TCP | Allow |
| 4 | All | Any | 3389 | TCP | Allow |
| 5 | All | 53 | Any | UDP | Allow |
| 6 | All | 123 | Any | UDP | Allow |
| 7 | All | - | - | ICMP | Deny |

- If we were to assume that this firewall is configures as implicit deny.
- This means that if the traffic does not match any of these rule numbers then it will automatically be dropped by the firewall.

## Screened subnet

- Most organisations will put their firewall at the ingress/egress point of the network
	- This is the point that separates the internet from the internal part of the network.
	- Assuming that we have a firewall installed between our two networks (internal network (where all confidential data is stored), screened subnet (holds services that need to be accessed by individuals on the internet)) and the internet at large.
	- Placing firewall in set place would mean that we can redirect traffic from internet directly to a subnet that does not contain any sensitive data perventing anyone from accessing the internal network.

## IPS (Intrusion Prevention System) rules

- It is usually integrated into an NGFW
- IPS usualy also monitors traffic that flows thrugh it 
- It's able to use signatures that have been loaded on that IPS to be able to recognise any type of malicious software that could be traversing network.
- Many rules built into an IPS use signature. 
- If IPS regnises the signature it then can make a decision ion whether to allow or disallow traffic to pass through.
- Some IPSs can work without specific signatures, they would merely be looking for anomalies.
- The IPS may have been configured to recognize what a generic intrusion might look like such as database injection. Meaning that upon passage through IPS it would jsut get blocked without looking for a specific signature.
- Rule base of an IPS is quite simmilar to the firewall rules. There will be a list of vulnerabilities and one can decide whethere a specific vulnerability hould be allowed to pass or not.
- Since there are thousands of signatures in an IPS one can summarise the rules and ake vroad decisions about whats allowed to pass and what is not by grouping the rules.
- These groups are often selected automatically by the IPS software or they can be manually made.
- With so many rules it if not uncommon to occasionally find a false positive.
- But customising the rolls inside the IPS a right balance can be struck between providing security and identifying something that might be a false positive.

## Segmenting the network

- There are several types of segmentation:
	- Physical
		- Physically separating devices
	- Logical
		- Using network switches with VLANs or virtual segmentation (very common in cloud-basedor virtual machine architectures).
	- Virtual Segmentation
		- A signle subnet might be dedicated for this high bandwidth application so that it can run as efficiently as possible. (anything that is done by other users on this network would not affect the throughput of this app)
- Sometimes  segmentation could be very strategic
	- For example users should not be communicating directly to a database server, instead they should be communicating to an application and the application server should not be communciating to the database server.
	- In this case there could be a firewall or some type of control list that would limit who might have access to a particular server.
- Some segmentation is required due to mandate or set of policies and procedures.
	- For example running a PCI compliance (payment card industry), this would require us to keep creadit card data completely separate from the other parts of our network.

## Acess Control lists (ACLs)

- Allow or disallow traffic
	- Groupings of categories
	- Source IP, Destination IP, port number, time of day, application, etc.
- Restict access to network devices
	- Limit by IP address or other identifier
	- Prevent regular user / non-admin
- Be careful when configuring these
	- You can accidentally lock yourself out
- List the permissions
	- Bob can read files
	- Fred can access network
	- James can access network 192.168.1.0/24 using tcp ports 80, 443, and 8088
- Many operating systems use ACLs to provide access to files

## Application allow list/deny list

- Any application can be dangerous, so a list would prevent anyone on the network or a specific person or a device from accessing untrusted apps
	- Vulnerabillities, trojan horses, malware
- Sucurity policy can control app execution
	- allow list, deny/block list
- Allow list
	- Nothing runs unless its approved
	- Very restrictive
- Deny list
	- Nothing on the 'bad list' can be excuted
	- Anti-virus, aanti-malware are examples

## Examples of allow and deny lists

- Decisions are made in the operating system
	- Often built in to the operating system management
- Application hash
	- Only allows applications with this unique idenntifier
- Cretificate
	- Allow digitally signed apps from certain publishers
- Path
	- Only run applications in these folders
- Network zone
	- The application can only run from this network zone

## Stateless vs Stateful

- Stateless 
	- Judges every packet on its own, against the rules. Doesn’t remember anything. Faster, but can’t tell a reply from an unsolicited packet.
- Stateful 
	- Remembers active connections (a “state table”). When you make a request out, it automatically allows the reply back, without a separate rule. This is what ct state established,related accept does in your nftables session this week.
## Stateless vs stateful
- Stateless: checks each packet on its own against the rules. No memory. Fast but dumb.
- Stateful: remembers active connections (state table). A reply to a request I made is
  allowed back automatically, no separate rule needed. The modern default.
  (In nftables: `ct state established,related accept`.)

## Allow vs drop vs reject
- Allow: let the packet through.
- Drop: silently discard it. The sender gets NO reply (looks "filtered" in nmap).
  Better for security — an attacker can't tell the port exists.
- Reject: discard it but send back "rejected" (e.g. ICMP port unreachable).
  Faster feedback, but tells the attacker something is there.
- Default-deny / implicit deny usually = DROP.
