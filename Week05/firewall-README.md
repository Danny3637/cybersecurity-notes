# Host Firewall - Kali VM1 (nftables)

A default-deny host firewall built with **nftables** on Kali VM1 ('10.10.10.1') as part of my Week 05 home lab. It blocks all incoming connections except them few I explicitly allow, while leaving my own outbound traffic free.


## The idea
- **Default-deny:** the 'input' chain's policy is 'drop'. Anything not matched by a rule is silently thrown away.
- **Stateful:** replies to connections *I* started are let back in automatically - no need for a rule per website.
- **Allow-lists:** SSH is reachable from one machine only (kali2)
- **Logged:** every dropped packet is recorded so Ican see what was blocked.

## The rules ('myfirewall.nft')

| Rule | What it allows | Why |
|---|---|---|
| 'iif "lo" accept' | loopback (the machine talking to itself) | tons of local software breaks without it |
| 'ct state established,related accept' | replies to my own connections | the stateful rule - lets web/apt answers back in |
| 'ip saddr 10.10.10.2 tcp dport 22 accept' | SSH, but only from kali2 | admin access from one trusted box only |
| 'ip6 nexthdr ipv6-icmp accept' | IPv6 ping (ICMPv6) | IPv6 needs it (neighbour discovery) to function |
| 'log prefix "DROP: " level info' | (logs, doesn't allow) | records everything about to be dropped |

'forward' = 'drop' (I'm not a router). 'output' = 'accept' (so apt/DNS/web work).

## Using it

```bash
sudo nft -f ~/myfirewall.nft		# load the rules
sudo nft list ruleset			# view what's loaded
sudo journalctl -k | grep "DROP: "      # view blocked packets
sudo nft flush ruleset			# wipe all rules (panic button)
```

## Reading the DROP logs

Each blocked packet logs fields like:
	- 'SRC' (who)
	- 'DPT' (which port)
	- 'TTL' (64 = Linux source, 128 = Windows)
	- 'Window' (1024 + lone SYN = an nmap scan)
Example:
A burst of drops from 'SRC=10.10.10.2' with randdom 'DPT's is kali2 running nmap against me.


## Known limitation

These rules are **not persistent** - they clear on reboot.
To make them survive a restart, install the file to 'etc/nftables.conf' and 'sudo systemctl enable --now nftables'. 
