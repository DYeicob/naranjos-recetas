# Manual de NaranjOS 0.1 «Semilla»

Bienvenido a NaranjOS. Este manual se abre con `naranjos-ayuda` o con **Super + H**.
Para moverte: flechas o espacio para avanzar, `/` para buscar y `q` para salir.

## 1. Primeros pasos

1. En la pantalla de inicio de sesión de NaranjOS escribe tu usuario y tu contraseña.
   (Si no está activada, inicia sesión en la consola y escribe `start-hyprland`.)
2. Se abre el escritorio.
3. Pulsa **Super + Enter** para abrir una terminal o **Super + Espacio** para buscar aplicaciones.
4. Para salir: **Super + Escape** y elige «Cerrar sesión».

La tecla **Super** es la de Windows.

## 2. Atajos de teclado

Puedes verlos en cualquier momento con **Super + K**.

| Atajo | Qué hace |
|---|---|
| Super + Enter | Abrir la terminal (foot) |
| Super + Espacio | Lanzador de aplicaciones (fuzzel) |
| Super + B | Navegador (Firefox) |
| Super + K | Chuleta de atajos |
| Super + H | Este manual |
| Super + Shift + B | Mostrar / ocultar la barra |
| Super + Ctrl + W | Menú de WiFi |
| Super + Ctrl + B | Menú de Bluetooth |
| Super + Ctrl + A | Mezclador de sonido |
| Super + Ctrl + S | Seguridad (naranjos-peel) |
| Super + Ctrl + V | Conectar / desconectar la VPN |
| Super + Ctrl + U | Permitir un USB bloqueado |
| Super + Ctrl + I | Idioma |
| Super + W | Cerrar la ventana |
| Super + F | Pantalla completa |
| Super + Shift + F | Maximizar |
| Super + T | Ventana flotante o en mosaico |
| Super + J | Cambiar la división de la ventana |
| Super + flechas | Mover el foco entre ventanas |
| Super + Shift + flechas | Mover la ventana |
| Super + clic izquierdo / derecho | Arrastrar / cambiar el tamaño |
| Super + 1 … 0 | Ir al escritorio 1 … 10 |
| Super + Shift + 1 … 0 | Mandar la ventana a otro escritorio |
| Super + S / Super + Alt + S | Mostrar el cajón / guardar la ventana en él |
| Super + Shift + S o Impr | Capturar una zona de la pantalla |
| Shift + Impr | Capturar la pantalla entera |
| Super + L | Bloquear |
| Super + Escape | Menú del sistema (bloquear, cerrar sesión, suspender, reiniciar, apagar) |
| Super + Shift + Escape | Salir de Hyprland inmediatamente |
| Super + Shift + R | Recargar el escritorio |

## 3. Cómo funciona el escritorio

NaranjOS usa **Hyprland**, un gestor de ventanas en mosaico: las ventanas se reparten
la pantalla solas, sin solaparse. Encima va la capa NaranjOS:

| Pieza | Programa | Configuración |
|---|---|---|
| Ventanas y atajos | Hyprland | `~/.config/hypr/hyprland.lua` |
| Barra superior | Waybar | `~/.config/waybar/config.jsonc` y `style.css` |
| Aspecto de apps GTK | GTK 3 | `~/.config/gtk-3.0/settings.ini` |
| Fondo de pantalla | hyprpaper | `~/.config/hypr/hyprpaper.conf` |
| Bloqueo | hyprlock | `~/.config/hypr/hyprlock.conf` |
| Inactividad | hypridle | `~/.config/hypr/hypridle.conf` |
| Avisos | mako | `~/.config/mako/config` |
| Lanzador | fuzzel | `~/.config/fuzzel/fuzzel.ini` |
| Terminal | foot | `~/.config/foot/foot.ini` |
| Shell | zsh | `~/.zshrc` |

La base de NaranjOS está en `/usr/share/naranjos/hypr/naranjos.lua` y se actualiza con
el sistema. **No la edites**: pon tus cambios en `~/.config/hypr/hyprland.lua`, debajo
de la línea `require(...)`. Lo que escribas ahí manda sobre la base.

Tus carpetas personales (Descargas, Documentos, Imágenes, Música y Vídeos) se crean solas al entrar,
con el nombre en tu idioma, y las aplicaciones las usan para guardar. Están apuntadas en
`~/.config/user-dirs.dirs` (puedes cambiarlas ahí).

Si rompes algo, `naranjos-config-usuario --forzar` vuelve a poner la configuración
original de NaranjOS (guarda la tuya con la extensión `.anterior`).

## 4. La barra superior

De izquierda a derecha:

- **NaranjOS**: abre el lanzador de aplicaciones.
- **Escritorios 1–5**: el activo sale en naranja. Pulsa uno para ir a él.
- **Ventana activa**: su título.
- **Reloj**, en el centro. Al pulsarlo muestra la fecha completa; al pasar el ratón, el calendario.
- **Escudo**: la seguridad (naranjos-peel). Naranja = todo bien, amarillo = algo que revisar, rojo = cortafuegos apagado
  o VPN caída. Con la VPN conectada sale un candado al lado. Clic derecho: conectar o desconectar la VPN.
- **Bluetooth**: pulsa para abrir el menú de Bluetooth (bluetui).
- **Volumen**: rueda del ratón para subir o bajar, clic para el mezclador (wiremix),
  clic derecho para silenciar.
- **Red**: pulsa para abrir el menú de WiFi (impala): elige la red con las flechas y pulsa Enter.
- **Brillo**: sube o baja con la rueda del ratón encima.
- **Batería**, **procesador** y **memoria**.
- **Botón de apagado**: el menú del sistema.

**Super + Shift + B** la oculta o la vuelve a mostrar.

### Sonido, WiFi y Bluetooth

El sonido lo gestiona **PipeWire**. Las teclas de volumen del portátil funcionan siempre,
también con la pantalla bloqueada. Desde la terminal: `wpctl status` muestra los dispositivos
y `wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%` cambia el volumen.

Los menús de WiFi, Bluetooth y sonido se abren en una ventana flotante. En todos ellos
te mueves con las flechas, **Enter** elige y **q** o **Esc** cierra; **?** muestra su ayuda.

## 5. Fondos de pantalla

Los fondos de NaranjOS están en `/usr/share/backgrounds/naranjos/`:

| Fichero | Fondo |
|---|---|
| `naranjos-01.jpg` | Pincelada (por defecto) |
| `naranjos-02.jpg` | Órbita |
| `naranjos-03.jpg` | Gajo |
| `naranjos-04.jpg` | Onda |
| `naranjos-05.jpg` | Tinta |
| `naranjos-06.jpg` | Topográfico |
| `naranjos-07.jpg` | Huerto |
| `naranjos-bloqueo.jpg` | Pantalla de bloqueo |

Para cambiarlo, edita la línea `path` de `~/.config/hypr/hyprpaper.conf` y vuelve a entrar en Hyprland.
`path` también puede ser la carpeta entera: con `timeout = 600` el fondo cambia solo cada 10 minutos.

## 6. Inactividad

- A los 2,5 minutos baja el brillo.
- A los 5 minutos se bloquea la sesión.
- A los 5,5 minutos se apaga la pantalla.

Se cambia en `~/.config/hypr/hypridle.conf`.

## 7. Capturas de pantalla

Se guardan en `Capturas`, dentro de tu carpeta de imágenes (`~/Imágenes/Capturas`), y además se copian al portapapeles, listas para pegar.

## 8. La terminal: zsh

zsh es la shell de NaranjOS. El prompt es así:

    yeicob@naranjos ~/proyecto (main) ❯

- Entre paréntesis sale la rama de git, si estás dentro de un repositorio.
- El símbolo ❯ se pone **rojo** si el último comando falló.
- Las sugerencias en gris salen de tu historial: **flecha derecha** las acepta.
- **Flecha arriba** busca en el historial lo que ya hayas empezado a escribir.
- **Tab** abre un menú de autocompletado por el que te mueves con las flechas.

Tus alias y ajustes van en `~/.zshrc`. La base está en `/etc/zsh/zshrc`.

Copiar y pegar desde la terminal: `wl-copy < fichero` y `wl-paste > fichero`.

## 9. La tienda: Flatpak y Flathub

Las aplicaciones gráficas (Firefox, LibreOffice, GIMP, Spotify, Discord…) se instalan desde
**Flathub**, que ya viene configurado:

| Orden | Qué hace |
|---|---|
| `flatpak search <texto>` | Buscar aplicaciones |
| `flatpak install flathub <id>` | Instalar (p. ej. `org.mozilla.firefox`) |
| `flatpak update` | Actualizar todas las aplicaciones |
| `flatpak uninstall <id>` | Desinstalar |
| `flatpak list --app` | Ver las instaladas |

Las aplicaciones instaladas aparecen en el lanzador (Super + Espacio) al volver a iniciar sesión.
Para compartir pantalla (Meet, Discord…) la app te deja elegir: haz clic en la pantalla que
quieras compartir (sale un marco naranja).

## 9b. zumo, el gestor de paquetes

| Orden | Qué hace |
|---|---|
| `zumo busca <texto>` | Buscar programas |
| `zumo instala <paquete>` | Instalar |
| `zumo quita <paquete>` | Desinstalar |
| `zumo actualiza` | Actualizar todo el sistema |
| `zumo info <paquete>` | Información de un paquete |
| `zumo limpia` | Quitar lo que sobra |
| `zumo ayuda` | Todas las órdenes |

## 9c. Seguridad: NaranjOS peel

`naranjos-peel` es el centro de seguridad de NaranjOS (**Super + Ctrl + S** o el escudo de la barra).
De serie: cortafuegos con toda la entrada cerrada, antivirus que vigila tus descargas, detector de
rootkits diario, protección USB (lo desconocido no funciona hasta que lo permites con **Super + Ctrl + U**), DNS cifrado (Quad9), MAC aleatoria en la WiFi y
kernel endurecido. El escudo se pone amarillo si hay algo a medias y rojo si el cortafuegos está apagado.

| Orden | Qué hace |
|---|---|
| `naranjos-peel` | Estado de todo |
| `naranjos-peel abre 22/tcp` | Abrir un puerto de entrada |
| `naranjos-peel cierra 22/tcp` | Cerrarlo |
| `naranjos-peel portal` | WiFi de hotel/tren con página de acceso (`portal fin` al acabar) |
| `naranjos-peel antivirus` | Estado del antivirus (`analiza`, `cuarentena`…) |
| `naranjos-peel auditoria` | Auditoría completa con Lynis |

### VPN (gratis)

NaranjOS trae su propia VPN sobre WireGuard, con **kill switch**: mientras está conectada, si el túnel
se cae no sale nada a Internet. Para tenerla gratis con Proton VPN (0 €, sin tarjeta):

1. Crea una cuenta gratuita en https://account.protonvpn.com
2. Downloads → WireGuard configuration → plataforma «GNU/Linux» → un servidor gratuito → Create, y descarga el `.conf`.
3. `naranjos-peel vpn importa ~/Descargas/<fichero>.conf proton`
4. **Super + Ctrl + V** (o `naranjos-peel vpn conecta`) para conectar y desconectar.

Sirve cualquier fichero de WireGuard (de otro proveedor o de tu router). `naranjos-peel vpn arranque si`
la conecta sola al encender.

Guía completa: `less /usr/share/doc/naranjos/peel.md`

## 9d. Idioma

NaranjOS se puede usar en varios idiomas. Pulsa **Super + Ctrl + I** y elige el tuyo, o en una terminal:

| Orden | Qué hace |
|---|---|
| `naranjos-idioma` | Idioma actual y lista de idiomas (★ = NaranjOS ya traducido) |
| `naranjos-idioma en` | Cambia **tu** idioma (se guarda en `~/.config/locale.conf`) |
| `naranjos-idioma --sistema en` | Cambia el idioma del sistema: pantalla de inicio de sesión y usuarios nuevos |

El cambio se ve al cerrar sesión y volver a entrar. Los programas (Firefox, las apps GTK…) también
cambian de idioma. ¿Quieres traducir NaranjOS al tuyo? Mira `/usr/share/doc/naranjos/traducir.md`.

## 9e. Herramientas del día a día

- **Portapapeles** (Super + V): lo último que copiaste, textos e imágenes. Solo en tu equipo; `naranjos-portapapeles borra` lo vacía.
- **Emojis** (Super + .): busca en español o en inglés; se escribe donde estés.
- **Texto de la pantalla** (Super + Ctrl + O): señala una zona y su texto queda en el portapapeles (sin internet).
- **Dictado** (Super + Ctrl + D): habla y vuelve a pulsar; el texto se escribe solo. Todo en tu equipo (whisper.cpp).
- **Grabar la pantalla** (Alt + Impr una zona, Alt + Mayús + Impr todo): se guarda en `Vídeos/Grabaciones`; el punto rojo de la barra la para.
- **Recordatorios** (Super + Ctrl + R): `naranjos-recuerda "llamar a Ana" a las 18:30`, `… en 20m`, `… mañana 9:00`.
- **El tiempo**: `naranjos-tiempo ciudad Ourense` y sale en la barra (Open-Meteo, gratis y sin cuenta).
- **Pantalla** (Super + Ctrl + P): tamaño del texto, escala de cada monitor y posición o transparencia de la barra.
- **Modo claro / oscuro** (Super + Ctrl + Mayús + T): cada cítrico tiene su versión clara.
- **Web apps**: `naranjos-webapp crea "WhatsApp" https://web.whatsapp.com` (ventana propia, en el menú).
- **Restablecer**: `naranjos-restablece barra` (o `todo`) vuelve a la configuración de NaranjOS y guarda la tuya como copia.
- **Llave de seguridad**: `naranjos-llave registra` y `sudo naranjos-llave activa` para usar una llave FIDO2 en sudo y el bloqueo.
- **Ventanas**: cada aplicación se vuelve a abrir en el escritorio donde la dejaste (`naranjos-ventanas olvida` para empezar de cero).
- **Complementos**: `naranjos-complementos instala <url-git>` añade atajos u órdenes de otros (te enseña lo que trae antes).
- **Programar**: `nvim` (Neovim con los colores del tema), `lazygit`, `lazydocker`, `btop` y `mise` (versiones de lenguajes).

## 9f. Más herramientas

- **Apps recomendadas** (Super + Mayús + A): Obsidian, LibreOffice, Kdenlive, GIMP, Steam, máquinas virtuales… con un clic.
- **Mantener despierto** (Super + Ctrl + C) y **salvapantallas** (a los 4 minutos; cualquier tecla lo quita).
- **Tu propio tema**: `naranjos-tema crea "Mi tema" 8a2be2` (oscuro y claro); se guarda en `~/.local/share/naranjos/temas`.
- **Fuente**: `naranjos-pantalla fuente "Nombre"` (o Super + Ctrl + P → Cambiar la fuente).
- **Terminal**: `cd` aprende tus carpetas (zoxide), Ctrl + R busca en el historial (fzf), `ls`/`ll`/`lt` con iconos (eza),
  `ver fichero` (bat), `rg` y `fd` para buscar; y `comprime`, `descomprime`, `convierte`, `video-ligero`, `usb-iso`, `formatea-usb`.
- **Contenedores**: Podman sin root (la orden `docker` también vale) y `lazydocker` para verlos.
- **Tailscale**: `naranjos-tailscale activa` une tus equipos en una red privada (gratis).
- **Arranque**: la naranja de NaranjOS mientras arranca; `sudo naranjos-inicio bonito` entra solo y te pide la contraseña en la
  pantalla de bloqueo. En el menú de arranque, «modo texto» enseña los mensajes si algo falla.

## 10. Problemas frecuentes

- **No se abre nada al pulsar un atajo:** abre una terminal con Super + Enter y mira si
  el programa existe con `which <programa>`.
- **La pantalla sale con un aviso rojo arriba:** hay un error en tu `hyprland.lua`. El aviso
  dice la línea. Corrígela; Hyprland recarga solo al guardar (o pulsa Super + Shift + R).
- **Tras actualizar quedan pocos atajos:** pulsa Super + Shift + R para recargar el escritorio.
- **Volver a la consola sin cerrar Hyprland:** Ctrl + Alt + **Fn** + F2 (en los portátiles
  MSI las teclas F necesitan Fn). Para volver: Ctrl + Alt + Fn + F1.
- **No puedo apagar desde el menú:** comprueba que polkit funciona con `systemctl status polkit`.
- **No suena nada:** `wpctl status` debe mostrar tu tarjeta. Si no aparece, cierra sesión y vuelve
  a entrar (el sonido arranca con la sesión). Comprueba también que no esté en silencio.
- **Enchufo un USB (ratón, memoria…) y no funciona:** está bloqueado por seguridad. Pulsa **Super + Ctrl + U**
  y permítelo; NaranjOS lo recordará.
- **Una WiFi pública no carga su página de acceso:** `naranjos-peel portal` (y luego `naranjos-peel portal fin`).
- **La pantalla de inicio de sesión no aparece o falla:** pulsa Ctrl + Alt + Fn + F2, inicia sesión
  ahí y desactívala con `sudo systemctl disable greetd`.

## 11. Lo que viene

- Bandeja de iconos en la barra.
- zumo en varios idiomas.
- Instalador de la ISO.
- Driver de NVIDIA para la gráfica dedicada.

## 9g. Novedades de la fase 6q (todo lo de Omarchy 4.5)

- **La orden única:** `naranjos` abre el menú; `naranjos ayuda` enseña todas las órdenes (con Tab se completan). Ejemplos: `naranjos tema pon lima`, `naranjos red`, `naranjos reloj añade`, `naranjos actualiza`.
- **Apariencia** (Super + Alt + A): tema y fondo con vista previa, modo claro u oscuro, fuente, tamaño del texto, barra, ventanas opacas, transparentes o de cristal, esquinas, animaciones y la pantalla de bloqueo.
- **Disposiciones** (Super + Ctrl + L): cada escritorio puede ir en mosaico, desplazable o flotante. **Modo escritorio** (menú → Aspecto): todo flotante y con dock, como un escritorio clásico.
- **Dock** (Super + Alt + D): apps fijadas, abiertas y el menú. Clic derecho en un icono para fijarlo. **Super + M** minimiza; **Super + Mayús + M** trae una ventana minimizada.
- **Paneles rápidos** (Super + Ctrl + 1…5): red, Bluetooth, sonido, energía y avisos.
- **Red con NetworkManager:** `sudo naranjos-red usa networkmanager` (trae tus WiFi guardadas; si no hay conexión en 40 s, vuelve sola a iwd). El panel de red tiene WiFi cercanas, estado, ping, test de velocidad, tráfico en directo, DNS (Cloudflare, Quad9, Google, Mullvad), compartir la WiFi por QR, banda 2,4/5 GHz, WiFi de empresa y portal cautivo (aviso en la barra). Para volver: `sudo naranjos-red usa iwd`.
- **Avisos:** Super + , abre el último; Ctrl para sus acciones; Alt lo quita; Ctrl + Alt: no molestar (también con la campana de la barra); Super + Mayús + Alt + , enseña los últimos diez.
- **Barra:** música (clic: pausa; rueda: siguiente/anterior), micrófono, idioma del teclado, novedades de NaranjOS, reloj mundial (clic derecho para añadir ciudades), portal cautivo, sesiones remotas y semana del año en el reloj.
- **Capturas:** al hacer una, el aviso tiene «Abrir» y «Editar» (flechas, texto, difuminar). **QR:** Super + Ctrl + Q lee un QR de la pantalla y lo copia (sin guardarlo en el historial).
- **Cámara:** Super + Ctrl + M graba la cámara; Super + Ctrl + Alt + M la pone en una ventanita encima de todo para tus grabaciones de pantalla.
- **Vídeo y presentaciones:** `naranjos-recorta video.mp4 1:20 3:05` recorta sin perder calidad; `naranjos-diapos charla.md` convierte un Markdown (diapositivas separadas por `---`) en una presentación con los colores del tema (Ctrl + P → PDF).
- **Reloj mundial:** Super + Ctrl + Alt + E.
- **Energía:** perfil distinto con cargador y con batería (Super + Ctrl + E); se aplica solo al enchufar y desenchufar.
- **Sistema:** memoria comprimida (zram), systemd-oomd (si un programa se come la memoria, se cierra él solo), aviso cuando un programa se cuelga con «Ver por qué», aviso de poco espacio antes de actualizar, test de velocidad del disco y de la red, kernel por defecto (`sudo naranjos-arranque kernel`), las dos Mayús = Bloq Mayús, luz del teclado con Ctrl + brillo, brillo de monitores externos (DDC/CI) y duplicar la pantalla (`naranjos-pantalla espejo`).
- **SSH:** `sudo naranjos-ssh servidor activa` (solo con clave, nunca con contraseña) y `naranjos-ssh agente activa`. **Otro equipo:** `naranjos-remoto` abre sus programas aquí por SSH (waypipe).
- **tmux:** con prefijo Ctrl + a y los colores de NaranjOS (chuleta: Super + Alt + K).
- **Juegos:** `naranjos-apps juegos` (Steam, RetroArch, Lutris y Heroic). **Webs de servicios:** menú → Utilidades (Microsoft 365, Slack, WhatsApp…; solo el acceso directo).
- **Huella dactilar** (si tu equipo tiene lector): `naranjos-huella guarda` y `sudo naranjos-huella activa`.
- **IA local (opcional):** `naranjos-ia instala` descarga Ollama solo en tu usuario; gratis, sin cuentas y sin que nada salga de tu equipo. NaranjOS no la trae de serie.
