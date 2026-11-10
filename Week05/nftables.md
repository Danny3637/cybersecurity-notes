# nftables - host firewall notes

## Structure (top → bottom)
- **table** → **chain** → **rule**
- `table inet filter` — `inet` = covers IPv4 AND IPv6 in one table
- chains attach to a **hook**: input (to me) / output (from me) / forward (through me)
- each chain has a **policy** = its default if no rule matches

## My setup
| Chain | Policy | Meaning |
|---|---|---|
| input | drop | default-deny: block all incoming unless allowed |
| output | accept | my outbound traffic flows freely |
| forward | drop | I'm not a router |

## Key rules & what they do
- `iif "lo" accept` — allow loopback (machine talks to itself)
- `ct state established,related accept` — STATEFUL: replies to my own connections come back in automatically
- `ip saddr 10.10.10.2 tcp dport 22 accept` — SSH allowed ONLY from kali2
- `ip6 nexthdr ipv6-icmp accept` — IPv6 needs ICMPv6 to work
- `log prefix "DROP: " level info` — log everything before it's dropped

## Commands
| Command | Does |
|---|---|
| `sudo nft -f file.nft` | load rules from a file |
| `sudo nft list ruleset` | show all loaded rules |
| `sudo nft flush ruleset` | wipe all rules |
| `sudo journalctl -k \| grep "DROP:"` | read dropped-packet logs |

## Key ideas (for the quiz)
- **Default-deny** = block all, then allow only what's needed
- **Stateful** = "I asked for this, so let the reply back in"
- **drop** = silent (looks "filtered" to a scanner) · **reject** = sends a "refused" reply (confirms the host exists) → default-deny uses drop
- **host** firewall = protects one machine · **network** firewall = protects a whole segment
- rules are NOT persistent — they clear on reboot unless saved to /etc/nftables.conf

## What I learned

I built a working host firewall with nftables that blocks everything coming in by default, then only lets through the few things I actually need. 
The clever part is the stateful rule — because `output` is open and `established,related` is allowed, my own browsing and apt still work even though nothing new can reach me from outside. 
I proved it worked by testing from kali2: SSH got in (it's on the allow-list), but ping was blocked and an nmap scan showed every other port as filtered, and I could see all of it in the DROP logs. 
The big gotcha is that these rules aren't persistent — they vanish on reboot unless I save them to /etc/nftables.conf, which I'll do when I harden the box.
