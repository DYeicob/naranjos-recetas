# NaranjOS peel — la piel que protege la naranja

`naranjos-peel` reúne la seguridad de NaranjOS. Ábrelo con **Super + Ctrl + S**, con un clic
en el escudo de la barra o escribiendo `naranjos-peel` en una terminal.

## Qué viene activado de serie

| Pieza | Qué hace |
|---|---|
| Cortafuegos (nftables) | Cierra **todas** las conexiones de entrada, salvo las respuestas a lo que tú inicias. Lo que sale de tu equipo no se toca. |
| DNS cifrado | Las consultas DNS van cifradas (DNS-over-TLS) a Cloudflare, el servicio más fiable (borra sus registros en 24 horas). Si no responde, se usa Quad9 (Suiza). |
| Red local invisible | LLMNR y mDNS apagados: en una WiFi pública tu portátil no anuncia su nombre. |
| MAC aleatoria | En cada red WiFi tu portátil usa una dirección MAC distinta, para que no te sigan de una red a otra. |
| Kernel endurecido | Ajustes `sysctl` que dificultan los ataques locales y de red (`/usr/lib/sysctl.d/60-naranjos-peel.conf`). |
| AppArmor | Cada programa con perfil solo puede tocar sus propios ficheros. De serie, en modo **aprendiz**. |
| Microcódigo | El initramfs de NaranjOS carga al arrancar los arreglos de seguridad de Intel y AMD para el procesador. |
| Auditoría | Lynis revisa todo el sistema y da una puntuación con consejos. |

## Antivirus

NaranjOS usa el motor libre **ClamAV** con su propia integración:

- **Vigila tu carpeta de descargas**: cada fichero nuevo que llega se analiza solo. Si es peligroso
  se mueve a la **cuarentena** (queda sin permisos, no se puede abrir) y sale un aviso.
- **Firmas al día**: se descargan solas cada 6 horas (la primera vez, unos 200 MB).
- **Análisis semanal** de tu carpeta personal, en segundo plano y con prioridad baja.
- No hay un programa vigilando todo el rato: solo se analiza cuando llega algo nuevo, así no gasta memoria.

| Orden | Qué hace |
|---|---|
| `naranjos-peel antivirus` | Estado: firmas, vigilancia, cuarentena |
| `naranjos-peel antivirus analiza [ruta]` | Analiza ahora (sin ruta: tus descargas) |
| `naranjos-peel antivirus actualiza` | Pone al día las firmas ya |
| `naranjos-peel antivirus vigila si\|no` | Enciende o apaga la vigilancia de descargas |
| `naranjos-peel antivirus cuarentena` | Lo que se ha bloqueado |
| `naranjos-peel antivirus restaura <nombre>` | Saca un fichero de la cuarentena (solo si estás seguro) |
| `naranjos-peel antivirus vacia` | Borra todo lo que hay en la cuarentena |

## Integridad (detector de rootkits)

Cada día NaranjOS comprueba que ningún programa del sistema ha sido modificado: los de los paquetes,
con las huellas que guarda zumo; los de la base del sistema, con huellas propias. Además busca señales
típicas de un rootkit: `/etc/ld.so.preload`, módulos del kernel sin fichero, usuarios con poderes de
root o sin contraseña, programas nuevos con permisos de root, ejecutables en carpetas temporales y
tarjetas de red espiando todo el tráfico. Si encuentra algo, el escudo se pone amarillo o rojo y sale un aviso.

| Orden | Qué hace |
|---|---|
| `naranjos-peel integridad` | Resultado de la última comprobación (con sudo, el detalle) |
| `sudo naranjos-peel integridad comprueba` | Comprobar ahora (unos minutos) |
| `sudo naranjos-peel integridad acepta` | Dar por buenos los cambios que hiciste tú |

## Protección USB

Un USB desconocido (memoria, ratón, teclado…) **no funciona hasta que lo permites**. Así un «teclado
falso» que escribe órdenes solo (Rubber Ducky y similares) no puede hacer nada. Lo que estaba conectado al
instalar NaranjOS peel (webcam, Bluetooth interno…) queda permitido, y lo que permites se recuerda.
Usa la autorización USB del propio kernel: no hay ningún programa extra vigilando.

| Orden | Qué hace |
|---|---|
| **Super + Ctrl + U** | Ver lo bloqueado y permitirlo |
| `naranjos-peel usb lista` | Dispositivos conectados y su estado |
| `naranjos-peel usb permite <1-3\|vid:pid\|todos>` | Permitir (y recordar) |
| `naranjos-peel usb olvida <vid:pid>` | Dejar de permitir |
| `naranjos-peel usb modo protegido\|abierto` | Bloquear lo desconocido o no |

**Ojo:** permite solo lo que acabas de enchufar tú. Si aparece bloqueado un «teclado» que no esperabas, no lo permitas.

## VPN

`naranjos-peel vpn` usa WireGuard con la red de NaranjOS (systemd-networkd), sin programas extra.
Mientras está conectada hay **kill switch**: si el túnel se cae, no sale nada a Internet hasta que
vuelva o desconectes. Al reiniciar se desconecta, salvo que actives `naranjos-peel vpn arranque si`.

Gratis con Proton VPN: cuenta gratuita en https://account.protonvpn.com → Downloads →
WireGuard configuration → «GNU/Linux» → un servidor gratuito → Create → descarga el `.conf` y
`naranjos-peel vpn importa ~/Descargas/<fichero>.conf proton`. Las claves se guardan en
`/etc/naranjos/vpn/` y solo las puede leer root.

## Órdenes

| Orden | Qué hace |
|---|---|
| `naranjos-peel` | Estado de todo |
| `naranjos-peel abre 22/tcp` | Abre un puerto de entrada (p. ej. para SSH) |
| `naranjos-peel cierra 22/tcp` | Lo vuelve a cerrar |
| `naranjos-peel vpn` | Estado de la VPN y cómo conseguir una gratis |
| `naranjos-peel vpn importa <f.conf> [nombre]` | Importa un perfil de WireGuard |
| `naranjos-peel vpn conecta [nombre]` | Conecta (Super + Ctrl + V) |
| `naranjos-peel vpn desconecta` | Desconecta y quita el kill switch |
| `naranjos-peel vpn lista` / `borra <nombre>` | Perfiles guardados / borrar uno |
| `naranjos-peel vpn arranque si\|no` | Conectar sola al encender |
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

## AppArmor

AppArmor encierra a cada programa que tiene perfil: aunque alguien lo engañe, no puede leer tus
documentos ni tocar el sistema más allá de lo que su perfil permite. NaranjOS carga los perfiles
con su propio servicio (`naranjos-apparmor.service`) en uno de dos modos:

- **aprendiz** (por defecto): los perfiles solo **avisan** de lo que bloquearían. Nada se rompe.
- **estricto**: los perfiles **bloquean** de verdad. Pásate cuando `naranjos-peel apparmor avisos`
  lleve unos días sin mostrar nada raro.

| Orden | Qué hace |
|---|---|
| `naranjos-peel apparmor` | Estado: perfiles cargados y modo |
| `naranjos-peel apparmor modo aprendiz\|estricto` | Cambia el modo |
| `naranjos-peel apparmor avisos [desde]` | Lo que ha frenado o frenaría (por defecto, hoy) |
| `naranjos-peel apparmor lista` | Todos los perfiles cargados |
| `naranjos-peel apparmor recarga` | Vuelve a cargar los perfiles de `/etc/apparmor.d` |

## Lo que viene

El kit opcional de ciberseguridad `naranjos-ciber`.
