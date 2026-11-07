# Windows Fundamentals (TryHackMe)

## Windows Editions

- It is the dominant OS in home use and corporate networks
- Windows Vista came after Windows XP, it had to many issues and was not accepted well by the community
- After end-of-life announcement for Windows XP next in line was Windows 7
- Windows 8.x was very short-lived like Vista
- the Windows 10 & 11 came around
- Windows 11 had two versions Home and PRO
- The current version of the Windows operating systems for servers is Windows Server 2025
- The Windows edition for the attached VM is Windows Server 2019 Standard.
- The encryption that could be enabled in PRO that couldnt be anebled in home version is BitLocker

## The File System

- The file system used in modern versions of Windows is the "New Technology File System (NTFS)"
- Before NTFS there was FAT16/FAT32 (File allocation Table) and HPFS (High Performance File System)
- FAT partitions are still in use today for example in USB devices, Micro SD cards
- NTFS is knows as a journaling file system. 
	- In case of a failure the file system can automatically repair the folders/files on disk using information stored in a log file.
		- This function is not possible with FAT.
- NTFS addreesses many of the limitations of the previous file systems, such as:
	- Supports files larger than 48GB
	- Set specific permissions on folders and files
	- Foolder and file compressions
	- Encryption (Encryption File System or EFS)
- Some features that are specific to NTFS:
	- On NTFS volumes you can set permissions that grant or deny access to files and folders
	- The permissions are:
		- Full control
		- Modify
		- Read & Execute
		- List folder contents
		- Read
		- Write
| Permissions | Meaning for Folders | Meaning for Files
|---|---|---|
| Read | Permits viewing and listing of files and subfolders | Permits viewing or accessing of the files contents |
| Write | Permits adding of files and subfolders | Permits writing to a file |
| Read & Execute | Permits viewing and listing of files and subfolders as well as executing of files; inherited by files and folders | Permits viweing and accessing of the files contents as well as executing of the file |
| List Folder Contents | Permits viewing and listing of files and subfolders as well as Executing of files; inherited by folders only | N/A |
| Modify | Permits reading and writing of files and subfolders; allows deletion of the folder | Permits reading and writtingof the file; allows deletion of the file |
| Full Control | Permits reading, writing, changing and deleting of files and subfolders | Permits reading, writing, changing and deleting of the file |

- Another feature of NTFS is Alternative Data Streams (ADS)
	- Alternative Data Streams (ADS) is a file attribut especific to windows NTFS
	- Every file has at leas tone data stream ($DATA) and ADS allows file to contain more than one stream of data.
	- Natively Windows Explorer doesnt display ADS to the user
		- There are 3rd party executables that can be used to view this data PowerShell allows you to view ADS for files.
			- Malware writers have used ADS to hide data.

## The Windows\System32 Fodlers

- C:\Windows folder contains Windows OS
- It doesnt have to reside in C drive and technically it could reside in a different folder
- This is where system enviroment variables, come into play.
	- The system enviroment variable for the Windows directory is %windir%
- System32 folder holds the important files that are critical for the operationg system.
- Accidentaly deleting any files or folders within System32 folder caan render Windows OS inoperational.

## User Accounts, Profiles, and Permissions

- There are two type sof user accounts on a typical local Windows system:
	- Administrator
	- Standard User
- Type of account will determine which actions user can perform
	- Administrator - can make changes to the system:
		- Add user
		- Delete users
		- Modify groups
		- Modify settings on the system etc.,
	- Standard user - can only make changes to folders/files attributed to the user & cant perform system-level changes, such as install programs
- There are several ways to determine which user account exists on the system.
	- Start menu > Type "Other User"
	- System Settings > Other Users
- Another way to access user information is using Local User and Group Management
	- Right click ont he Start Menu, click run and type lusrmgr.msc
- Dialog Box allows us to open items quickly

## User Account Control

- Majority of home users are logged into their Windows OS as  a local administrator
- Normally a user doesnt need to be logged in as administrator to run daily tasks.
	- Doing so can compromise security of the system as it makes easier for malware to infect the system
- To protect the local user Microsoft introduce User Account Control (UAC).
- UAC by default doesnt apply for the built-in local administrator account.

### How does UAC work?

- When a user with an account type of administrator logs into a system the current session doesnt run with elevated permissions.
- When an operation requiring higher-level priveleges needs to execute, the user will be prompted to confirm of they permit the operation to run.
- On the Shortcut you will see a shield icon, it is an indicator that prior to running the os will ask you for permission to make changes.

## Settings and the Control Panel

- On a Windows the primary locations to make changes are the Settings menu and the Control Panel.
- For a long time control panel was the go to to make changes. Windows 8 changed that by introducing  a settings menu.
- To see which programs are installed on the system:
	- Control panel > Programs > Programs and Features.

## Task Manager

- The task manager provides information about the applications and processes currently runing on the system

