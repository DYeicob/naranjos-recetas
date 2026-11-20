# NaranjOS peel — la piel que protege la naranja

`naranjos-peel` reúne la seguridad de NaranjOS. Ábrelo con **Super + Ctrl + S**, con un clic
en el escudo de la barra o escribiendo `naranjos-peel` en una terminal.

## Qué viene activado de serie

| Pieza | Qué hace |
|---|---|
| Cortafuegos (nftables) | Cierra **todas** las conexiones de entrada, salvo las respuestas a lo que tú inicias. Lo que sale de tu equipo no se toca. |
| DNS cifrado | Las consultas DNS van cifradas (DNS-over-TLS) a Quad9, que no guarda tu IP y bloquea dominios de malware y phishing. |
| Red local invisible | LLMNR y mDNS apagados: en una WiFi pública tu portátil no anuncia su nombre. |
| MAC aleatoria | En cada red WiFi tu portátil usa una dirección MAC distinta, para que no te sigan de una red a otra. |
| Kernel endurecido | Ajustes `sysctl` que dificultan los ataques locales y de red (`/usr/lib/sysctl.d/60-naranjos-peel.conf`). |
| Auditoría | Lynis revisa todo el sistema y da una puntuación con consejos. |

## Órdenes

| Orden | Qué hace |
|---|---|
| `naranjos-peel` | Estado de todo |
| `naranjos-peel abre 22/tcp` | Abre un puerto de entrada (p. ej. para SSH) |
| `naranjos-peel cierra 22/tcp` | Lo vuelve a cerrar |
| `naranjos-peel bloqueados` | Lo último que ha frenado el cortafuegos |
| `naranjos-peel dns estricto` | DNS siempre cifrado: si la red lo bloquea, no hay DNS |
| `naranjos-peel dns flexible` | Cifrado siempre que se pueda (por defecto) |
| `naranjos-peel red-local si` | Hace visible tu equipo en la red local (impresoras, Chromecast, equipos por nombre) |
| `naranjos-peel red-local no` | Lo vuelve invisible (por defecto) |
| `naranjos-peel portal` | WiFi de hotel/tren con página de acceso: usa el DNS de la red un rato |
| `naranjos-peel portal fin` | Vuelve al DNS cifrado |
| `naranjos-peel auditoria` | Auditoría completa con Lynis |

## Ficheros

- `/etc/nftables.conf`: reglas del cortafuegos. No hace falta tocarlo: usa `abre` y `cierra`.
- `/etc/nftables.d/*.nft`: reglas extra. Los puertos abiertos están en `naranjos-puertos.nft`.
- `/usr/lib/systemd/resolved.conf.d/50-naranjos-peel.conf`: DNS cifrado.
- `/etc/iwd/main.conf`: `AddressRandomization=network` (MAC aleatoria).

## Problemas frecuentes

- **Una red WiFi no me deja entrar a su página de acceso:** `naranjos-peel portal`, inicia sesión
  en el navegador y luego `naranjos-peel portal fin`.
- **Un programa necesita que le lleguen conexiones** (servidor web, juego en LAN…):
  `naranjos-peel abre <puerto>`.
- **No encuentro mi impresora o mi Chromecast:** `naranjos-peel red-local si`.
- **Quiero apagar el cortafuegos un momento:** `sudo systemctl stop nftables`
  (vuelve con `sudo systemctl start nftables`). No es recomendable.

## Lo que viene

VPN propia (WireGuard, con kill switch), antivirus que vigila Descargas, detector de rootkits,
protección USB, AppArmor y el kit opcional de ciberseguridad `naranjos-ciber`.
