# Manual de NaranjOS 0.1 «Semilla»

Bienvenido a NaranjOS. Este manual se abre con `naranjos-ayuda` o con **Super + H**.
Para moverte: flechas o espacio para avanzar, `/` para buscar y `q` para salir.

## 1. Primeros pasos

1. Inicia sesión con tu usuario en la consola.
2. Escribe `start-hyprland` para abrir el escritorio.
3. Pulsa **Super + Enter** para abrir una terminal o **Super + Espacio** para buscar aplicaciones.
4. Para salir: **Super + Escape** y elige «Cerrar sesión».

La tecla **Super** es la de Windows.

## 2. Atajos de teclado

Puedes verlos en cualquier momento con **Super + K**.

| Atajo | Qué hace |
|---|---|
| Super + Enter | Abrir la terminal (foot) |
| Super + Espacio | Lanzador de aplicaciones (fuzzel) |
| Super + K | Chuleta de atajos |
| Super + H | Este manual |
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

## 3. Cómo funciona el escritorio

NaranjOS usa **Hyprland**, un gestor de ventanas en mosaico: las ventanas se reparten
la pantalla solas, sin solaparse. Encima va la capa NaranjOS:

| Pieza | Programa | Configuración |
|---|---|---|
| Ventanas y atajos | Hyprland | `~/.config/hypr/hyprland.lua` |
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

## 4. Fondos de pantalla

Los fondos de NaranjOS están en `/usr/share/backgrounds/naranjos/`. Para cambiarlo,
edita la línea `path` de `~/.config/hypr/hyprpaper.conf` y vuelve a entrar en Hyprland.
`path` también puede ser una carpeta; con `timeout = 600` el fondo cambia cada 10 minutos.

## 5. Inactividad

- A los 2,5 minutos baja el brillo.
- A los 5 minutos se bloquea la sesión.
- A los 5,5 minutos se apaga la pantalla.

Se cambia en `~/.config/hypr/hypridle.conf`.

## 6. Capturas de pantalla

Se guardan en `~/Imágenes/Capturas` y además se copian al portapapeles, listas para pegar.

## 7. La terminal: zsh

zsh es la shell de NaranjOS. El prompt es así:

    yeicob@naranjos ~/proyecto (main) ❯

- Entre paréntesis sale la rama de git, si estás dentro de un repositorio.
- El símbolo ❯ se pone **rojo** si el último comando falló.
- Las sugerencias en gris salen de tu historial: **flecha derecha** las acepta.
- **Flecha arriba** busca en el historial lo que ya hayas empezado a escribir.
- **Tab** abre un menú de autocompletado por el que te mueves con las flechas.

Tus alias y ajustes van en `~/.zshrc`. La base está en `/etc/zsh/zshrc`.

Copiar y pegar desde la terminal: `wl-copy < fichero` y `wl-paste > fichero`.

## 8. zumo, el gestor de paquetes

| Orden | Qué hace |
|---|---|
| `zumo busca <texto>` | Buscar programas |
| `zumo instala <paquete>` | Instalar |
| `zumo quita <paquete>` | Desinstalar |
| `zumo actualiza` | Actualizar todo el sistema |
| `zumo info <paquete>` | Información de un paquete |
| `zumo limpia` | Quitar lo que sobra |
| `zumo ayuda` | Todas las órdenes |

## 9. Problemas frecuentes

- **No se abre nada al pulsar un atajo:** abre una terminal con Super + Enter y mira si
  el programa existe con `which <programa>`.
- **La pantalla sale con un aviso rojo arriba:** hay un error en tu `hyprland.lua`. El aviso
  dice la línea. Corrígela; Hyprland recarga solo al guardar.
- **Volver a la consola sin cerrar Hyprland:** Ctrl + Alt + **Fn** + F2 (en los portátiles
  MSI las teclas F necesitan Fn). Para volver: Ctrl + Alt + Fn + F1.
- **No puedo apagar desde el menú:** tu usuario tiene que estar en el grupo `wheel`.

## 10. Lo que viene

- Barra superior con WiFi, sonido, batería y reloj (Waybar).
- Sonido con PipeWire, Bluetooth, y menús de WiFi y Bluetooth.
- Pantalla de inicio de sesión gráfica.
- Tienda de aplicaciones (Flatpak) e instalador de la ISO.
