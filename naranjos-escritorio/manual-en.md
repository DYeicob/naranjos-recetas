# NaranjOS 0.1 «Semilla» manual

Welcome to NaranjOS. Open this manual with `naranjos-ayuda` or **Super + H**.
To move around: arrows or space to scroll, `/` to search and `q` to quit.

## 1. Getting started

1. On the NaranjOS login screen, type your user name and password.
   (If it is not enabled, log in on the console and type `start-hyprland`.)
2. The desktop opens.
3. Press **Super + Enter** to open a terminal or **Super + Space** to search for applications.
4. To leave: **Super + Escape** and choose «Log out».

The **Super** key is the Windows key.

## 2. Keyboard shortcuts

You can see them at any time with **Super + K**.

| Shortcut | What it does |
|---|---|
| Super + Enter | Open the terminal (foot) |
| Super + Space | Application launcher (fuzzel) |
| Super + B | Web browser (Firefox) |
| Super + K | Shortcut cheat sheet |
| Super + H | This manual |
| Super + Shift + B | Show / hide the bar |
| Super + Ctrl + W | Wi-Fi menu |
| Super + Ctrl + B | Bluetooth menu |
| Super + Ctrl + A | Sound mixer |
| Super + Ctrl + S | Security (naranjos-peel) |
| Super + Ctrl + I | Language |
| Super + W | Close the window |
| Super + F | Fullscreen |
| Super + Shift + F | Maximize |
| Super + T | Floating or tiled window |
| Super + J | Toggle the window split |
| Super + arrows | Move focus between windows |
| Super + Shift + arrows | Move the window |
| Super + left / right click | Drag / resize |
| Super + 1 … 0 | Go to workspace 1 … 10 |
| Super + Shift + 1 … 0 | Send the window to another workspace |
| Super + S / Super + Alt + S | Show the drawer / put the window in it |
| Super + Shift + S or Print | Capture an area of the screen |
| Shift + Print | Capture the whole screen |
| Super + L | Lock |
| Super + Escape | System menu (lock, log out, suspend, reboot, power off) |
| Super + Shift + Escape | Quit Hyprland immediately |
| Super + Shift + R | Reload the desktop |

## 3. How the desktop works

NaranjOS uses **Hyprland**, a tiling window manager: windows share the screen
by themselves, without overlapping. On top of it sits the NaranjOS layer:

| Part | Program | Configuration |
|---|---|---|
| Windows and shortcuts | Hyprland | `~/.config/hypr/hyprland.lua` |
| Top bar | Waybar | `~/.config/waybar/config.jsonc` and `style.css` |
| GTK app look | GTK 3 | `~/.config/gtk-3.0/settings.ini` |
| Wallpaper | hyprpaper | `~/.config/hypr/hyprpaper.conf` |
| Lock screen | hyprlock | `~/.config/hypr/hyprlock.conf` |
| Idle | hypridle | `~/.config/hypr/hypridle.conf` |
| Notifications | mako | `~/.config/mako/config` |
| Launcher | fuzzel | `~/.config/fuzzel/fuzzel.ini` |
| Terminal | foot | `~/.config/foot/foot.ini` |
| Shell | zsh | `~/.zshrc` |

The NaranjOS base lives in `/usr/share/naranjos/hypr/naranjos.lua` and is updated with
the system. **Do not edit it**: put your changes in `~/.config/hypr/hyprland.lua`, below
the line that loads the base. Whatever you write there overrides the base.

If you break something, `naranjos-config-usuario --forzar` restores the original
NaranjOS configuration (yours is kept with the `.anterior` extension).

## 4. The top bar

From left to right:

- **NaranjOS**: opens the application launcher.
- **Workspaces 1–5**: the active one is orange. Click one to go there.
- **Active window**: its title.
- **Clock**, in the middle. Click it for the full date; hover it for the calendar.
- **Shield**: security (naranjos-peel). Orange = all good, yellow = something to check, red = firewall off.
- **Bluetooth**: click to open the Bluetooth menu (bluetui).
- **Volume**: mouse wheel to turn it up or down, click for the mixer (wiremix),
  right click to mute.
- **Network**: click to open the Wi-Fi menu (impala): choose the network with the arrows and press Enter.
- **Brightness**: scroll over it to change it.
- **Battery**, **processor** and **memory**.
- **Power button**: the system menu.

**Super + Shift + B** hides or shows it again.

### Sound, Wi-Fi and Bluetooth

Sound is handled by **PipeWire**. The laptop volume keys always work,
even on the lock screen. From the terminal: `wpctl status` shows the devices
and `wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%` changes the volume.

The Wi-Fi, Bluetooth and sound menus open in a floating window. In all of them
you move with the arrows, **Enter** selects and **q** or **Esc** closes; **?** shows their help.

## 5. Wallpapers

The NaranjOS wallpapers are in `/usr/share/backgrounds/naranjos/`:

| File | Wallpaper |
|---|---|
| `naranjos-01.jpg` | Pincelada · brushstroke (default) |
| `naranjos-02.jpg` | Órbita · orbit |
| `naranjos-03.jpg` | Gajo · segment |
| `naranjos-04.jpg` | Onda · wave |
| `naranjos-05.jpg` | Tinta · ink |
| `naranjos-06.jpg` | Topográfico · topographic |
| `naranjos-07.jpg` | Huerto · orchard |
| `naranjos-bloqueo.jpg` | Lock screen |

To change it, edit the `path` line in `~/.config/hypr/hyprpaper.conf` and log in to Hyprland again.
`path` can also be the whole folder: with `timeout = 600` the wallpaper changes every 10 minutes.

## 6. Idle

- After 2.5 minutes the brightness goes down.
- After 5 minutes the session is locked.
- After 5.5 minutes the screen turns off.

Change it in `~/.config/hypr/hypridle.conf`.

## 7. Screenshots

They are saved in `Screenshots`, inside your pictures folder, and also copied to the
clipboard, ready to paste.

## 8. The terminal: zsh

zsh is the NaranjOS shell. The prompt looks like this:

    yeicob@naranjos ~/project (main) ❯

- The git branch is shown in brackets when you are inside a repository.
- The ❯ symbol turns **red** if the last command failed.
- The grey suggestions come from your history: **right arrow** accepts them.
- **Up arrow** searches the history for what you have started typing.
- **Tab** opens a completion menu you move through with the arrows.

Your aliases and settings go in `~/.zshrc`. The base is in `/etc/zsh/zshrc`.

Copy and paste from the terminal: `wl-copy < file` and `wl-paste > file`.

## 9. The store: Flatpak and Flathub

Graphical applications (Firefox, LibreOffice, GIMP, Spotify, Discord…) are installed from
**Flathub**, which is already set up:

| Command | What it does |
|---|---|
| `flatpak search <text>` | Search for applications |
| `flatpak install flathub <id>` | Install (e.g. `org.mozilla.firefox`) |
| `flatpak update` | Update all applications |
| `flatpak uninstall <id>` | Uninstall |
| `flatpak list --app` | List the installed ones |

Installed applications show up in the launcher (Super + Space) after logging in again.
To share your screen (Meet, Discord…) the app lets you choose: click the screen you
want to share (an orange frame appears).

## 9b. zumo, the package manager

zumo's commands are in Spanish for now (an English version is coming):

| Command | What it does |
|---|---|
| `zumo busca <text>` | Search for programs |
| `zumo instala <package>` | Install |
| `zumo quita <package>` | Uninstall |
| `zumo actualiza` | Update the whole system |
| `zumo info <package>` | Information about a package |
| `zumo limpia` | Remove what is not needed |
| `zumo ayuda` | All the commands |

## 9c. Security: NaranjOS peel

`naranjos-peel` is the NaranjOS security centre (**Super + Ctrl + S** or the shield on the bar).
Out of the box: a firewall with all incoming traffic closed, encrypted DNS (Quad9), random Wi-Fi
MAC address, an invisible computer on the local network and a hardened kernel.

| Command | What it does |
|---|---|
| `naranjos-peel` | Status of everything |
| `naranjos-peel abre 22/tcp` | Open an incoming port |
| `naranjos-peel cierra 22/tcp` | Close it |
| `naranjos-peel red-local si` | Show printers / Chromecast by name (`red-local no` to hide again) |
| `naranjos-peel portal` | Hotel/train Wi-Fi with a login page (`portal fin` when done) |
| `naranjos-peel auditoria` | Full audit with Lynis |

Full guide: `less /usr/share/doc/naranjos/en/peel.md`

## 9d. Language

NaranjOS can be used in several languages. Press **Super + Ctrl + I** and pick yours, or in a terminal:

| Command | What it does |
|---|---|
| `naranjos-idioma` | Current language and list of languages (★ = NaranjOS already translated) |
| `naranjos-idioma en` | Changes **your** language (saved in `~/.config/locale.conf`) |
| `naranjos-idioma --sistema en` | Changes the system language: login screen and new users |

You will see the change after logging out and in again. Programs (Firefox, GTK apps…) change
language too. Want to translate NaranjOS into yours? See `/usr/share/doc/naranjos/traducir.md`.

## 10. Common problems

- **Nothing opens when I press a shortcut:** open a terminal with Super + Enter and check that
  the program exists with `which <program>`.
- **A red warning appears at the top of the screen:** there is an error in your `hyprland.lua`. The
  warning tells you the line. Fix it; Hyprland reloads by itself when you save (or press Super + Shift + R).
- **Only a few shortcuts work after an update:** press Super + Shift + R to reload the desktop.
- **Go to the console without closing Hyprland:** Ctrl + Alt + **Fn** + F2 (on MSI laptops
  the F keys need Fn). To come back: Ctrl + Alt + Fn + F1.
- **I can't power off from the menu:** check that polkit works with `systemctl status polkit`.
- **No sound:** `wpctl status` must show your sound card. If it doesn't, log out and in again
  (sound starts with the session). Also check it isn't muted.
- **A public Wi-Fi doesn't load its login page:** `naranjos-peel portal` (then `naranjos-peel portal fin`).
- **The login screen doesn't appear or fails:** press Ctrl + Alt + Fn + F2, log in there
  and disable it with `sudo systemctl disable greetd`.

## 11. Coming next

- Tray icons on the bar.
- Own VPN, antivirus and more NaranjOS peel pieces.
- zumo in several languages.
- The ISO installer.
- NVIDIA driver for the dedicated graphics card.
