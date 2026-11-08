# Active Directory (AD) Basics

## Introduction

- AD simplifies the management of devices and users within a corporate enviroment.

## Windows Domains

- On a small network with only a few computers administering set network is pretty easy as each computer can be configured manually
- Within a large business having several offices it is pretty impossible to do so a Windows domain must be used
- Windows domain is a group of users and computers under the administration of a given business
- The main idea of it is to centralise the administration of common components of a Windows computer network in a single repository called Active Directory.
- Server that runs D services is known as a Domain Controller (DC)
- The main advantages are:
	- Centralised identity management: all users across the network can be confugyred from active directory with minimum effort
	- Managing security policies: You can configure security policies directly from AD amd apply them to users and computers across the network as needed,

## Active Directory

- The core of any Windows Domain is the Active Directory Domain Service (AD DS)
- This service is essentially a catalogue that holds the information as 'objects' that exist ont he network.
- Across many objects supported by AD some of them are:
	- Users
	- Groups
	- Machines
	- Printers
	- Shares etc.

### Users

- Users is one of the most common object types in AD 
- Users are one of the objects known as "Security Principals"
	- This means that thye can be authenticated by the domain and can be assigned priviliges over resources like files or printers.
- Users can be used to represent two types of entities:
	- People: users will generally represent persons in your organisation that need to access the network, like employees
	- Services: you can also define users to be used by services like IIS or MSSQL. Every single service requires a user to run, but service users are different from regular users as they will only have the privileges needed to run their specific service.

### Machines

- Machines are another type of object.
- For every computer that joins the AD domain a machine object wil be created.
- Machines are also considered "Security principals" and are assigned an account just as any regular user.
- The machine accounts themselves are elocal administrators on the assigned computer, they are generally not supposed to be accessed by anyone except the computer itself.
- Machine Account passwords are automatically rotated out and are generally comprised of 120 characters
- Identifying machine accounts is relatively easy.
	- They folow specific naming schedule
	- The machine account name is the computers name followed by a $

### Security Groups

- Security groups are also considered security principals and therefore can have privileges over resources ont he network.
- Groups can have both users and machines as memebers. If needed groups can inclued other groups as well
- Several groups are created by default in a domain that can be used to grant specific provileges to users
	- Some examples:
| Security Group | Description|
|---|---|
| Domain Admins | Users of this group have administrative privileges over the entire domain. BY default, they can administer any computer ont he domain, including the DC's |
| Server Operators | Users in this group can administer Domain Controllers. They cannot change any administrative group memeberships |
| Backup operators | Users in this group are allowed to access any file, ignoring their permissions. They are used to perform backups of data on computers |
| Account operators | Users in this group can create or modify oother accounts in the domain | 
| Domain Users | Includes all existing user accounts int he domain |
| Domain Computers | Includes all existing computers int he domain |
| Domain Controllers | Includes all existing DC's on the Domain |

### Active Directory Users and Computers

- It is used to configure users, groups or machines in AD
- To do so:
	- Log in to Domain Controller and run "Active Directory Users and Computers"
		- This will open up a window where one can see hierarchy of users, computers and groups that exist in the domain.
		- These objects are organised in Organisational Units (OUs) which are container objects that allow you to classify users and machines.
- OUs are mainly used to define sets of users with similar policing requirements
- Some containers are created by Windows automatically these are:
| Name | Description |
|---|---|
| Builtin | Contrains default groups available to any Windows host |
| Computers | Any machine joining the network will be put there by default. They can be moved if needed |
| Domain controllers | Default OU that contains the DCs in your network |
| Users | Default users and groups that apply to a domain-wide context |
| Managed Service Accounts | Hoolds accounts used by services in your Windows domain |

### Security Groups vs OUs

- OUs
	- Are handy for applying policies to users and computers, which include specific configurations that pertain to sets of users depending on their particular role in the neterprise
	- A user can only be a member of a single OU at a time as it wouldnt make any sense to try to apply two different sets of poolicies to a single user
- Security groups
	- Are used to grant permissions over resources.
	- One user can be a part of many groups as itis needed to grant access over multiple resources such as printers.

 
## Managing Users in AD

- By default OUs are protected against accidental deletion. To delete OU I need to enable the Advanced Features in the View Menu

### Delegation

- In AD I can give specific users some control over some OUs.
- This process is known as Delegation and allows me to grant users specific privileges to perform advanced tasks on OUs without needing a Domin Administrator to step in.
- One of the most common cases is granting IT support the privileges to reset other low-privilege users passwords.

## Managing computers in AD

- By default machines that join a domain (except for the DCs) will be put in the container called "Computers".
- Theres no golden rule on how to orgaise machines. However, an excellent starting point is segregating devices according to their use.
- In general devices would be divided into at least three of the following categories:
	- Workstations
		- Workstations are one of the most commong devices within an AD domain.
		- Each user in the domain will most likely be logging into a workstation.
		- This device is normally used to do daily work and normal browsing activities
		- These devices should never have a privilged user signed into them
	- Servers
		- Servers are the second most common device within an AD domain
		- Servers are generally used to provide services to users or other servers
	- Domain Controllers
		- DC are the third most common device within an AD domain
		- DC allow you to manage the AD domain
		- These devices are often deemed the most sensitive devices within network as they contain hashed paswords for all user accounts withint hte enviroment

## Group policies

- The main idea is to be able to deploy different policies for each OU individually.
- This way we can push different configurations and security baselines to users depending on their department.
- Windows manages such policies through Group Policy Objects (GPO)
- GPO are simply a collection of settings that can be applied to OUs. 
- GPOs can contain policies aimed at either users or computers, allowing you to set a baseline on specific machines and identities.

### GPO distribution

- GPOs are distributed to the network via a network share called SYSVOL which is stored in DC
- All users in a domain should typically have ccess to this share over the network to sync their GPOs periodically.
- The SYSVOL share points by default to the C:\Windows\SYSBOL\sysvol\ directory on each of the DCs in our network.
- Once the change has been done to any GPOs it might take up to 2 hours for computers to catch up
- If a computers sync to its GPO needed immediately then this command can be ran:
	- C:\> gpupdate /force

## Authentication Methods

- When using windows domains all credentials are stored in the DC
- whenever a user tries to auuthenticate to a service using domain credentials, the srvice will need to ask the DC to verify if they are correct.
- Two protocols can be used for network authentication in windows domains:
	- Kerberos:
		- Used by any recent version of windows
		- this is the default protocol in any recent domain
	- NetNTLM:
		- Legacy authentication protocol kept for compatibillity purposes
- While NetNTLM should be considered obsolete, most networks will have both protocols enabled

### Kerberos Authentication

- Kerberos is the default authentication protocol for any recent version of Windows
- Users who log into a service using Kerbertos will be assigned a ticket
	- Thickets should be thought of as proof of a previous authentication
- Users with tickets can present them to a service to demonstrate they have already authenticated into the network before and are therefore enabled to use it
- When kerberos is used for authentication the following process happens:
	- The user sends their username and a timestamp encrypted using a key derived from their password to the Key Distribution center (KDC), a service usually installed ont he DC in charge of creating Kerbertos tickets on the network.
	- The KDC will create and send back a Ticket Granting Ticket (TGT) which will allow the user to request additional tickets to access specific services.
	- The need for tickets to assign more tickets sound weird by it prevents user from enetering their credentials every time.
	- Along with TGT a Session Key is given to the user which they will need to generate the following requests
- The TGT is encrypted using krgbt accounts password hash and therefore the suer cant access its contents.
- It is essential to know that TGT includes a copy of the Session Key as part of its contents and the KDC has no need to store the Session Key as it can recover acopy by decrypting the TGT if needed.
- When a user wants to connect to a service on th network like a share, website or database, they will use their TGT to ask the KDC for a Ticket Granting Service TGS.
	- TGS are tickets that allow connection only to the specific service they were created for.
	- To request a TGS the uuser will send their username and a timestamp encrypted using the Session Key along with the TGT and a Service Principal Name SPN which indicated the service and server name we intend to access.
- As a result the KDC will send us a TGS along witha Service Session Key which we will need to authenticate the service we want to access.
- The TGS is encrypted using a key derived from the Service Owner Hash.
- The Service Owner is the user or a machine account that the service runs under.
- The TGS contains a copy of the service Session Key on its encrypted contents so that the Service Owner can access it by decrypting the TGS.
- the TGS can be sent to the desired service to authenticate and establish a connection.
- The service will use its configured accounts password hash to decrypt the TGS and validate the service session key

### NetNTLM Authentication

- NetNTLM works using a challenge-response mechanism. 
- The entire process is as follows:
	1. The client sends an authentication request to the server they want to access
	2. The server generates a random number and sends it as a challenege to the client
	3. The client combines their NTLM password hash with the challenge (and other knwon data) to generate a response tot he challenge and sends it back tot he server for verification.
	4. The server forwards the challenge and the response to the DC for verification
	5. The domain controller uses the challenge to recalculate the response and compares it to the original response sent by the client. If they both match, the client is authenticated; otherwise, access is denied. The authentication result is sent back to the server.
	6. The server forwards the authenticationresult to the client.

- Note that the users password (or hash) is never transmitted throught the network for security.
- The described process applies when using a domain acccount. If a local account is used, the server can verify the response to the challenge itself without requiring interraction with the DC since it hhas the password hash stored locally on its SAM.

## Trees, Forests and Trusts

- So far we've discussed how to manage a single domain the role of a DC and how it joins computers, server and users.
- As companies grow having a signle domain for a company is good enough to start but in time some additional needs might push you into having more than one.

### Trees

- For example your company expands to a different country with different laws, regulations that require to update GPOs to comply. In addition each country has IT teams and people in both countries need to manage resources that correspond to each country without interfering with the other team.
- AD supports integrating multiple domains so that youc an partition your network into units that can be managed independently.
- If you have two domains that share the same namespace those domains can be joined into a tree.
- This partitioned structure gives us better control over who can access what in the domain
- A new security group needs to be introduced when talking about trees and forests.
- The enterprise Admins group will grant a user administrative privileges over all of an enterprises domains.
- Each domain would still have its Domain Admins with administrator privileges over their single domains and the enterprise Admins who can control everything int he enterprise.

### Forests

- The Domains you manage can also be configured in different namespaces. 
* suppose your company keeps growing and acquires anothe company.
- When both companies merge you will probably have different domain trees.
- The union of several trees with different namespaces into the same network is known as a forest.

### Trust Relationships

- Having multiple domains organised in trees and forests allows you to have a nice compartmentalised network in terms of management and resources. But at a certain point a user might need to access a shared file in one of other companys servers. For this to happen domains arranged in trees and forests are joined otgether by trust relationship.
- the simplest trust relationship that can be established is a one-way trust relationship.
	- In a one way trust relationship if company 1 domain trusts company 2 domain this means that a user on company 2 domain can be authorised to access resources in Company 1 domain
	- The direction of the one-way trust relationship is contrary to that of the access direction
- Two-way trust relationship can also be made to allow both domains to mutually authorise users from the other. By, default joining several domains under a tree or a forest will form a two-way trust relationsip.
- Having a trust relationship between domains doesn't automatically grant access to all resources on other domains. Once a trust relationship is established, you have the chance to authorise users across different domains, but it's up to you what is actually authorised or not.

## Linking terms to my lab
| Term | Where you saw it in DC01 |
|---|---|
| Domain | lab.local: created with “Add a new forest” |
| Domain Controller | DC01 in ADUC → Domain Controllers (DC Type GC) |
| Forest / Tree | one forest, one tree: lab.local |
| NetBIOS name | LAB → login LAB\Administrator |
| OU vs container | Users / Computers = containers (no GPOs). Domain Controllers = a real OU |
| User object | Administrator, Guest, krbtgt in ADUC → Users |
| Computer object | DC01 (machine account DC01$) |
| Security groups | Domain Admins, Enterprise Admins, DnsAdmins, Protected Users… |
| GPO | not created yet. The Default Domain Policy is edited in the next lab |
| Kerberos | port 88 open in your nmap scan · krbtgt signs every ticket |
| NTLM / SMB | port 445 in nmap |
| LDAP | ports 389 / 636 in nmap |
| DNS (AD’s backbone) | port 53 · _msdcs / _tcp SRV records in DNS Manager · the multi-homed DNS fix |
| Why it’s the #1 target | all of the above lives in NTDS.dit on DC01: own it and you own every account |


