# NaranjOS peel — the skin that protects the orange

`naranjos-peel` brings together NaranjOS security. Open it with **Super + Ctrl + S**, by clicking
the shield on the bar or by typing `naranjos-peel` in a terminal.

## What is enabled out of the box

| Piece | What it does |
|---|---|
| Firewall (nftables) | Closes **all** incoming connections, except replies to what you start. Outgoing traffic is not touched. |
| Encrypted DNS | DNS queries are encrypted (DNS-over-TLS) to Quad9, which does not log your IP and blocks malware and phishing domains. |
| Invisible on the local network | LLMNR and mDNS are off: on a public Wi-Fi your laptop does not announce its name. |
| Random MAC | On each Wi-Fi network your laptop uses a different MAC address, so you can't be tracked from one network to another. |
| Hardened kernel | `sysctl` settings that make local and network attacks harder (`/usr/lib/sysctl.d/60-naranjos-peel.conf`). |
| Audit | Lynis checks the whole system and gives a score with advice. |

## Commands

The sub-commands are in Spanish; most also accept an English alias (`open`, `close`, `audit`…).

| Command | What it does |
|---|---|
| `naranjos-peel` | Status of everything |
| `naranjos-peel abre 22/tcp` | Opens an incoming port (e.g. for SSH) |
| `naranjos-peel cierra 22/tcp` | Closes it again |
| `naranjos-peel bloqueados` | The latest things the firewall stopped |
| `naranjos-peel dns estricto` | Always-encrypted DNS: if the network blocks it, there is no DNS |
| `naranjos-peel dns flexible` | Encrypted whenever possible (default) |
| `naranjos-peel red-local si` | Makes your computer visible on the local network (printers, Chromecast, computers by name) |
| `naranjos-peel red-local no` | Makes it invisible again (default) |
| `naranjos-peel portal` | Hotel/train Wi-Fi with a login page: uses the network's DNS for a while |
| `naranjos-peel portal fin` | Back to encrypted DNS |
| `naranjos-peel auditoria` | Full audit with Lynis |

## Files

- `/etc/nftables.conf`: firewall rules. No need to touch it: use `abre` and `cierra`.
- `/etc/nftables.d/*.nft`: extra rules. Open ports are in `naranjos-puertos.nft`.
- `/usr/lib/systemd/resolved.conf.d/50-naranjos-peel.conf`: encrypted DNS.
- `/etc/iwd/main.conf`: `AddressRandomization=network` (random MAC).

## Common problems

- **A Wi-Fi network won't let me reach its login page:** `naranjos-peel portal`, log in
  in the browser and then `naranjos-peel portal fin`.
- **A program needs incoming connections** (web server, LAN game…):
  `naranjos-peel abre <port>`.
- **I can't find my printer or Chromecast:** `naranjos-peel red-local si`.
- **I want to switch the firewall off for a moment:** `sudo systemctl stop nftables`
  (back with `sudo systemctl start nftables`). Not recommended.

## Coming next

Own VPN (WireGuard, with kill switch), antivirus watching Downloads, rootkit detector,
USB protection, AppArmor and the optional `naranjos-ciber` security kit.
