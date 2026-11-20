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

Si rompes algo, `naranjos-config-usuario --forzar` vuelve a poner la configuración
original de NaranjOS (guarda la tuya con la extensión `.anterior`).

## 4. La barra superior

De izquierda a derecha:

- **NaranjOS**: abre el lanzador de aplicaciones.
- **Escritorios 1–5**: el activo sale en naranja. Pulsa uno para ir a él.
- **Ventana activa**: su título.
- **Reloj**, en el centro. Al pulsarlo muestra la fecha completa; al pasar el ratón, el calendario.
- **Escudo**: la seguridad (naranjos-peel). Naranja = todo bien, amarillo = algo que revisar, rojo = cortafuegos apagado.
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

Cada orden tiene también su nombre en inglés (`install`, `remove`, `update`…).

## 9c. Seguridad: NaranjOS peel

`naranjos-peel` es el centro de seguridad de NaranjOS (**Super + Ctrl + S** o el escudo de la barra).
De serie: cortafuegos con toda la entrada cerrada, DNS cifrado (Quad9), MAC aleatoria en la WiFi y
kernel endurecido. El escudo se pone amarillo si hay algo a medias y rojo si el cortafuegos está apagado.

| Orden | Qué hace |
|---|---|
| `naranjos-peel` | Estado de todo |
| `naranjos-peel abre 22/tcp` | Abrir un puerto de entrada |
| `naranjos-peel cierra 22/tcp` | Cerrarlo |
| `naranjos-peel portal` | WiFi de hotel/tren con página de acceso (`portal fin` al acabar) |
| `naranjos-peel auditoria` | Auditoría completa con Lynis |

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
- **Una WiFi pública no carga su página de acceso:** `naranjos-peel portal` (y luego `naranjos-peel portal fin`).
- **La pantalla de inicio de sesión no aparece o falla:** pulsa Ctrl + Alt + Fn + F2, inicia sesión
  ahí y desactívala con `sudo systemctl disable greetd`.

## 11. Lo que viene

- Bandeja de iconos en la barra.
- VPN propia, antivirus y más piezas de NaranjOS peel.
- Instalador de la ISO.
- Driver de NVIDIA para la gráfica dedicada.
