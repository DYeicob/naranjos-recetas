# Licencias de NaranjOS

_Generado por `naranjos-tanda-6i2.sh` el 2026-11-25. Se instala en `/usr/share/doc/naranjos/LICENCIAS.md`._

NaranjOS está hecho casi entero de software libre. Cada paquete conserva la licencia de su proyecto original;
lo propio de NaranjOS se publica así:

| Qué | Licencia |
|---|---|
| Recetas (PKGBUILD), `zumo`, `fotos`, `peel`, `naranjos-*` y demás herramientas propias | GPL-3.0-or-later |
| Arte: logo y fondos de pantalla (`naranjos-fondos`) | CC BY-SA 4.0 · © Yeicob (DYeicob) |
| Cursor (`naranjos-cursor`, Bibata Modern recoloreado) | GPL-3.0-or-later |

## Código fuente

Para cumplir la GPL y las demás licencias, el código fuente **exacto** de cada paquete (la receta, los parches y la
fuente original, tal y como se compiló) está en la Release
[`naranjos-fuentes`](https://github.com/DYeicob/naranjos-recetas/releases/tag/naranjos-fuentes): un fichero
`<receta>-<versión>.src.tar.gz` por paquete. Desde NaranjOS: `zumo fuentes <paquete>`.

Los textos completos de las licencias están en `/usr/share/licenses/<paquete>/` (y los genéricos en
`/usr/share/licenses/common/`). Desde NaranjOS: `zumo licencia <paquete>`.

## Lo que no es software libre (pero se puede redistribuir)

| Paquete | Qué es | Licencia |
|---|---|---|
| `linux-firmware` | Firmware de WiFi, gráficas, Bluetooth… que necesita el hardware | Licencias de cada fabricante que permiten redistribuirlo (`WHENCE`) |
| `sof-firmware` | Firmware de sonido de Intel (SOF) | BSD-3-Clause + licencia de Intel |
| `intel-ucode` | Microcódigo de los procesadores Intel | Licencia de Intel (redistribuible sin modificar) |
| `naranjos-shim` | `shimx64.efi` firmado por Microsoft para arrancar con Secure Boot | BSD-2-Clause; binario de Ubuntu (`shim-signed` 1.59+15.8-0ubuntu2), su fuente es el paquete `shim` de Ubuntu |

Las aplicaciones de Flathub (por ejemplo Firefox) llegan con Flatpak y tienen su propia licencia; no forman parte
del repositorio `naranjos-core`.

## Todos los paquetes

| Paquete | Versión | Licencia (SPDX) |
|---|---|---|
| `abseil-cpp` | 20260817.0-1 | Apache-2.0 |
| `acl` | 2.4.0-1 | LGPL-2.1-or-later · GPL-2.0-or-later |
| `adwaita-icon-theme` | 50.0-1 | LGPL-3.0-or-later OR CC-BY-SA-3.0 |
| `alsa-lib` | 1.2.16.1-1 | LGPL-2.1-or-later |
| `alsa-utils` | 1.2.16-1 | GPL-2.0-or-later |
| `apparmor` | 4.1.8-1 | GPL-2.0-only · LGPL-2.1-only |
| `appstream` | 1.2.3-1 | LGPL-2.1-or-later |
| `aquamarine` | 0.16.0-1 | BSD-3-Clause |
| `at-spi2-core` | 2.60.6-1 | LGPL-2.1-or-later |
| `atkmm` | 2.28.5-1 | LGPL-2.1-or-later |
| `attr` | 2.6.0-1 | LGPL-2.1-or-later · GPL-2.0-or-later |
| `autoconf` | 2.73-1 | GPL-3.0-or-later |
| `automake` | 1.18.1-1 | GPL-2.0-or-later |
| `bash` | 5.3-1 | GPL-3.0-or-later |
| `bc` | 7.0.3-1 | BSD-2-Clause |
| `binutils` | 2.47-1 | GPL-3.0-or-later |
| `bison` | 3.8.2-1 | GPL-3.0-or-later |
| `bluetui` | 0.8.2-1 | GPL-3.0-only |
| `bluez` | 5.87-1 | GPL-2.0-only AND LGPL-2.1-or-later |
| `brightnessctl` | 0.5.1-1 | MIT |
| `brotli` | 1.2.0-1 | MIT |
| `btrfs-progs` | 6.19.1-1 | GPL-2.0-only · LGPL-2.1-only |
| `bubblewrap` | 0.12.0-1 | LGPL-2.0-or-later |
| `bzip2` | 1.0.8-1 | bzip2-1.0.6 |
| `cairo` | 1.18.4-1 | LGPL-2.1-only OR MPL-1.1 |
| `cairomm` | 1.14.6-1 | LGPL-2.0-or-later |
| `cargo-c` | 0.10.24-1 | MIT |
| `clamav` | 1.5.5-1 | GPL-2.0-only |
| `cmake` | 4.4.2-1 | BSD-3-Clause |
| `coreutils` | 9.11-1 | GPL-3.0-or-later |
| `curl` | 8.21.0-1 | curl |
| `dbus` | 1.16.2-1 | AFL-2.1 · GPL-2.0-or-later |
| `dejagnu` | 1.6.3-1 | GPL-3.0-or-later |
| `diffutils` | 3.12-1 | GPL-3.0-or-later |
| `duktape` | 2.7.0-1 | MIT |
| `e2fsprogs` | 1.47.4-1 | GPL-2.0-or-later · LGPL-2.0-or-later · MIT |
| `efibootmgr` | 18-1 | GPL-2.0-or-later |
| `efivar` | 39-1 | LGPL-2.1-or-later |
| `elfutils` | 0.195-1 | GPL-2.0-or-later · LGPL-3.0-or-later |
| `expat` | 2.8.3-1 | MIT |
| `expect` | 5.45.4-1 | LicenseRef-expect |
| `fakeroot` | 2.1.4-1 | GPL-3.0-or-later |
| `fcft` | 3.3.3-1 | MIT |
| `file` | 5.48-1 | BSD-2-Clause |
| `findutils` | 4.11.0-1 | GPL-3.0-or-later |
| `flatpak` | 1.18.4-1 | LGPL-2.1-or-later |
| `flex` | 2.6.4-1 | BSD-2-Clause |
| `fmt` | 12.2.0-1 | MIT |
| `fontconfig` | 2.18.3-1 | HPND AND Unicode-DFS-2016 |
| `foot` | 1.28.0-2 | MIT |
| `freetype2` | 2.14.3-1 | FTL OR GPL-2.0-or-later |
| `fribidi` | 1.0.16-1 | LGPL-2.1-or-later |
| `fuse3` | 3.18.2-1 | GPL-2.0-only AND LGPL-2.1-only |
| `fuzzel` | 1.15.0-1 | MIT |
| `gawk` | 5.4.1-2 | GPL-3.0-or-later |
| `gcc` | 16.2.0-1 | GPL-3.0-or-later · GCC-exception-3.1 |
| `gdbm` | 1.26-1 | GPL-3.0-or-later |
| `gdk-pixbuf2` | 2.44.7-1 | LGPL-2.1-or-later |
| `gettext` | 1.0-1 | GPL-3.0-or-later · LGPL-2.1-or-later |
| `giflib` | 6.1.3-1 | MIT |
| `git` | 2.55.0-1 | GPL-2.0-only |
| `glaze` | 9.1.0-1 | MIT |
| `glib2` | 2.88.3-1 | LGPL-2.1-or-later |
| `glibc` | 2.44-1 | LGPL-2.1-or-later · GPL-2.0-or-later |
| `glibmm` | 2.66.10-1 | LGPL-2.1-or-later |
| `glslang` | 16.5.0-1 | BSD-2-Clause AND BSD-3-Clause AND GPL-3.0-or-later AND Apache-2.0 AND MIT |
| `gmp` | 6.3.0-1 | LGPL-3.0-or-later · GPL-2.0-or-later |
| `gnu-efi` | 4.0.4-1 | GPL-2.0-or-later · BSD-2-Clause · BSD-3-Clause |
| `gnupg` | 2.5.21-1 | GPL-3.0-or-later |
| `gperf` | 3.3-1 | GPL-3.0-or-later |
| `gpgme` | 2.1.2-1 | LGPL-2.1-or-later |
| `greetd` | 0.10.3-2 | GPL-3.0-only |
| `grep` | 3.12-1 | GPL-3.0-or-later |
| `grim` | 1.5.0-1 | MIT |
| `groff` | 1.24.1-1 | GPL-3.0-or-later |
| `grub` | 2.14-1 | GPL-3.0-or-later |
| `gsettings-desktop-schemas` | 50.1-1 | LGPL-2.1-or-later |
| `gst-plugins-base` | 1.28.6-1 | LGPL-2.1-or-later |
| `gstreamer` | 1.28.6-1 | LGPL-2.1-or-later |
| `gtk-layer-shell` | 0.10.1-1 | LGPL-3.0-or-later AND GPL-3.0-or-later AND MIT |
| `gtk3` | 3.24.52-1 | LGPL-2.1-or-later |
| `gtkmm3` | 3.24.11-1 | LGPL-2.1-or-later |
| `gzip` | 1.14-1 | GPL-3.0-or-later |
| `harfbuzz` | 14.3.1-1 | MIT |
| `hicolor-icon-theme` | 0.18-1 | GPL-2.0-only |
| `highway` | 1.4.0-1 | Apache-2.0 OR BSD-3-Clause |
| `hwdata` | 0.410-1 | GPL-2.0-or-later |
| `hyprcursor` | 0.1.13-1 | BSD-3-Clause |
| `hyprgraphics` | 0.6.0-1 | BSD-3-Clause |
| `hypridle` | 0.1.8-1 | BSD-3-Clause |
| `hyprland` | 0.57.2-2 | BSD-3-Clause |
| `hyprland-guiutils` | 0.2.2-2 | BSD-3-Clause |
| `hyprland-protocols` | 0.8.0-1 | BSD-3-Clause |
| `hyprlang` | 0.6.8-1 | LGPL-3.0-only |
| `hyprlock` | 0.9.7-1 | BSD-3-Clause |
| `hyprpaper` | 0.8.5-1 | BSD-3-Clause |
| `hyprtoolkit` | 0.6.0-1 | BSD-3-Clause |
| `hyprutils` | 0.14.3-1 | BSD-3-Clause |
| `hyprwayland-scanner` | 0.4.6-1 | BSD-3-Clause |
| `hyprwire` | 0.3.1-1 | BSD-3-Clause |
| `iana-etc` | 20260805-1 | MIT |
| `impala` | 0.9.0-1 | GPL-3.0-only |
| `inetutils` | 2.8-1 | GPL-3.0-or-later |
| `iniparser` | 4.3.2-1 | MIT |
| `intel-ucode` | 20260812-1 | LicenseRef-Intel-Microcode |
| `iproute2` | 7.1.0-1 | GPL-2.0-or-later |
| `iso-codes` | 4.20.1-1 | LGPL-2.1-or-later |
| `iwd` | 3.12-1 | LGPL-2.1-or-later |
| `json-c` | 0.18-1 | MIT |
| `json-glib` | 1.10.8-1 | LGPL-2.1-or-later |
| `jsoncpp` | 1.9.8-1 | MIT |
| `kbd` | 2.10.0-1 | GPL-2.0-or-later |
| `kmod` | 34.2-1 | LGPL-2.1-or-later · GPL-2.0-or-later |
| `lcms2` | 2.19.1-1 | MIT |
| `less` | 704-1 | GPL-3.0-or-later · BSD-2-Clause |
| `libarchive` | 3.8.9-1 | BSD-2-Clause |
| `libassuan` | 3.0.2-1 | LGPL-2.1-or-later |
| `libcanberra` | 0.30-1 | LGPL-2.1-or-later |
| `libcap` | 2.78-1 | BSD-3-Clause · GPL-2.0-only |
| `libdisplay-info` | 0.4.0-1 | MIT |
| `libdrm` | 2.4.134-1 | MIT |
| `libei` | 1.6.0-1 | MIT |
| `libepoxy` | 1.5.10-1 | MIT |
| `libevdev` | 1.13.6-1 | MIT |
| `libffi` | 3.8.0-1 | MIT |
| `libfontenc` | 1.1.9-1 | MIT |
| `libfs` | 1.0.10-1 | MIT |
| `libfyaml` | 0.9.6-1 | MIT |
| `libgcrypt` | 1.12.2-1 | LGPL-2.1-or-later |
| `libglvnd` | 1.7.0-1 | MIT |
| `libgpg-error` | 1.61-1 | LGPL-2.1-or-later |
| `libice` | 1.1.2-1 | MIT |
| `libidn2` | 2.3.8-1 | LGPL-3.0-or-later · GPL-2.0-or-later · GPL-3.0-or-later |
| `libinih` | 62-1 | BSD-3-Clause |
| `libinput` | 1.31.3-1 | MIT |
| `libjpeg-turbo` | 3.2.0-1 | BSD-3-Clause AND IJG AND Zlib |
| `libjxl` | 0.12.0-1 | BSD-3-Clause |
| `libksba` | 1.8.0-1 | LGPL-3.0-or-later · GPL-2.0-or-later |
| `libmnl` | 1.0.5-1 | LGPL-2.1-or-later |
| `libnftnl` | 1.3.2-1 | GPL-2.0-or-later |
| `libnl` | 3.12.0-1 | LGPL-2.1-only |
| `libogg` | 1.3.6-1 | BSD-3-Clause |
| `libpciaccess` | 0.19-1 | MIT |
| `libpipeline` | 1.5.8-1 | GPL-3.0-or-later |
| `libpng` | 1.6.58-1 | libpng-2.0 |
| `libpsl` | 0.23.3-1 | MIT |
| `librsvg` | 2.62.3-1 | LGPL-2.1-or-later |
| `libseccomp` | 2.6.1-1 | LGPL-2.1-only |
| `libsigcpp2` | 2.12.1-1 | LGPL-2.1-or-later |
| `libsm` | 1.2.6-1 | MIT |
| `libtasn1` | 4.21.0-1 | LGPL-2.1-or-later · GPL-3.0-or-later |
| `libtirpc` | 1.3.7-1 | BSD-3-Clause |
| `libtool` | 2.6.2-1 | GPL-2.0-or-later · LGPL-2.1-or-later |
| `libunistring` | 1.4.2-1 | LGPL-3.0-or-later · GPL-2.0-or-later |
| `libuv` | 1.52.1-1 | MIT AND CC-BY-4.0 |
| `libva` | 2.24.1-1 | MIT |
| `libvorbis` | 1.3.7-1 | BSD-3-Clause |
| `libwebp` | 1.6.0-1 | BSD-3-Clause |
| `libx11` | 1.8.13-1 | MIT |
| `libxau` | 1.0.12-1 | MIT |
| `libxaw` | 1.0.16-1 | MIT |
| `libxcb` | 1.17.0-1 | MIT |
| `libxcomposite` | 0.4.7-1 | MIT |
| `libxcrypt` | 4.5.2-1 | LGPL-2.1-or-later |
| `libxcursor` | 1.2.3-1 | MIT |
| `libxcvt` | 0.1.3-1 | MIT |
| `libxdamage` | 1.1.7-1 | MIT |
| `libxdmcp` | 1.1.5-1 | MIT |
| `libxext` | 1.3.7-1 | MIT |
| `libxfixes` | 6.0.2-1 | MIT |
| `libxfont2` | 2.0.9-1 | MIT |
| `libxft` | 2.3.9-1 | MIT |
| `libxi` | 1.8.3-1 | MIT |
| `libxinerama` | 1.1.6-1 | MIT |
| `libxkbcommon` | 1.13.2-1 | MIT |
| `libxkbfile` | 1.2.0-1 | MIT |
| `libxml2` | 2.15.3-1 | MIT |
| `libxmlb` | 0.3.30-1 | LGPL-2.1-or-later |
| `libxmu` | 1.3.1-1 | MIT |
| `libxpm` | 3.5.19-1 | MIT |
| `libxpresent` | 1.0.2-1 | MIT |
| `libxrandr` | 1.5.5-1 | MIT |
| `libxrender` | 0.9.12-1 | MIT |
| `libxres` | 1.2.3-1 | MIT |
| `libxshmfence` | 1.3.3-1 | MIT |
| `libxss` | 1.2.5-1 | MIT |
| `libxt` | 1.3.1-1 | MIT |
| `libxtst` | 1.2.5-1 | MIT |
| `libxv` | 1.0.13-1 | MIT |
| `libxvmc` | 1.0.15-1 | MIT |
| `libxxf86dga` | 1.1.7-1 | MIT |
| `libxxf86vm` | 1.1.7-1 | MIT |
| `libzip` | 1.11.4-1 | BSD-3-Clause |
| `linux-firmware` | 20261019-1 | LicenseRef-linux-firmware · GPL-2.0-only |
| `linux-naranjos` | 7.3.5-1 | GPL-2.0-only |
| `linux-pam` | 1.7.2-1 | GPL-2.0-only · BSD-3-Clause |
| `llvm` | 22.1.8-1 | Apache-2.0 WITH LLVM-exception |
| `lua` | 5.4.8-1 | MIT |
| `lynis` | 3.1.7-1 | GPL-3.0-only |
| `lz4` | 1.10.0-1 | BSD-2-Clause · GPL-2.0-or-later |
| `m4` | 1.4.21-1 | GPL-3.0-or-later |
| `make` | 4.4.1-1 | GPL-3.0-or-later |
| `make-ca` | 1.16.1-1 | MIT · GPL-3.0-or-later |
| `mako` | 1.11.0-1 | MIT |
| `man-db` | 2.13.1-1 | GPL-2.0-or-later |
| `man-pages` | 6.18-1 | LicenseRef-man-pages |
| `mesa` | 26.1.7-2 | MIT AND BSD-3-Clause AND SGI-B-2.0 |
| `meson` | 1.12.0-1 | Apache-2.0 |
| `mpc` | 1.4.1-2 | LGPL-3.0-or-later |
| `mpdecimal` | 4.0.1-1 | BSD-2-Clause |
| `mpfr` | 4.2.2-1 | LGPL-3.0-or-later |
| `mtdev` | 1.1.7-1 | MIT |
| `muparser` | 2.3.5-1 | BSD-2-Clause |
| `naranjos-arranque` | 0.2.0-1 | GPL-3.0-or-later |
| `naranjos-base` | 13.1-14 | GPL-3.0-or-later |
| `naranjos-cursor` | 0.1.0-1 | GPL-3.0-or-later |
| `naranjos-entorno` | 0.1.0-1 | GPL-3.0-or-later |
| `naranjos-escritorio` | 0.9.0-1 | GPL-3.0-or-later |
| `naranjos-fondos` | 0.2.1-1 | CC-BY-SA-4.0 |
| `naranjos-fotos` | 0.1.0-1 | GPL-3.0-or-later |
| `naranjos-idiomas` | 0.1.10-1 | GPL-3.0-or-later |
| `naranjos-initramfs` | 0.3.0-1 | GPL-3.0-or-later |
| `naranjos-keyring` | 20261121-1 | GPL-3.0-or-later |
| `naranjos-peel` | 0.5.6-1 | GPL-3.0-or-later |
| `naranjos-portales` | 0.1.0-2 | GPL-3.0-or-later |
| `naranjos-red` | 0.1.1-1 | GPL-3.0-or-later |
| `naranjos-shim` | 15.8-1 | BSD-2-Clause |
| `naranjos-zsh` | 0.1.0-1 | GPL-3.0-or-later |
| `nasm` | 3.02-1 | BSD-2-Clause |
| `ncurses` | 6.6-1 | MIT-open-group |
| `nftables` | 1.1.7-1 | GPL-2.0-only |
| `nghttp2` | 1.70.0-1 | MIT |
| `ninja` | 1.13.2-1 | Apache-2.0 |
| `npth` | 1.8-1 | LGPL-2.1-or-later |
| `openssh` | 10.5p1-3 | SSH-OpenSSH |
| `openssl` | 4.0.1-1 | Apache-2.0 |
| `ostree` | 2026.4-1 | LGPL-2.0-or-later |
| `p11-kit` | 0.26.5-1 | BSD-3-Clause |
| `pacman` | 7.1.0-2 | GPL-2.0-or-later |
| `pango` | 1.58.2-1 | LGPL-2.1-or-later |
| `pangomm` | 2.46.5-1 | LGPL-2.1-or-later |
| `patch` | 2.8-1 | GPL-3.0-or-later |
| `pcre2` | 10.47-1 | BSD-3-Clause |
| `perl` | 5.44.0-1 | GPL-1.0-or-later · Artistic-1.0-Perl |
| `pinentry` | 1.3.3-1 | GPL-2.0-or-later |
| `pipewire` | 1.6.8-2 | MIT |
| `pixman` | 0.46.4-1 | MIT |
| `pkgconf` | 3.0.5-2 | ISC |
| `polkit` | 127-1 | LGPL-2.0-or-later |
| `popt` | 1.19-1 | MIT |
| `procps-ng` | 4.0.7-2 | GPL-2.0-or-later · LGPL-2.1-or-later |
| `psmisc` | 23.7-1 | GPL-2.0-or-later |
| `pugixml` | 1.16-1 | MIT |
| `python` | 3.14.7-2 | PSF-2.0 |
| `python-attrs` | 26.1.0-1 | MIT |
| `python-flit-core` | 4.0.2-1 | BSD-3-Clause |
| `python-jinja` | 3.1.6-1 | BSD-3-Clause |
| `python-mako` | 1.4.1-1 | MIT |
| `python-markupsafe` | 3.0.3-1 | BSD-3-Clause |
| `python-packaging` | 26.3-1 | Apache-2.0 |
| `python-pyparsing` | 3.3.3-1 | MIT |
| `python-setuptools` | 84.0.0-1 | MIT |
| `python-wheel` | 0.48.0-1 | MIT |
| `python-yaml` | 6.0.3-1 | MIT |
| `re2` | 2025.11.05-1 | BSD-3-Clause |
| `readline` | 8.3-1 | GPL-3.0-or-later |
| `rust` | 1.97.1-1 | Apache-2.0 OR MIT |
| `sbc` | 2.2-1 | GPL-2.0-or-later AND LGPL-2.1-or-later |
| `sbsigntools` | 0.9.5-1 | GPL-3.0-or-later |
| `scdoc` | 1.11.5-1 | MIT |
| `sdbus-cpp` | 2.3.1-1 | LGPL-2.1-only |
| `seatd` | 0.9.3-1 | MIT |
| `sed` | 4.10-1 | GPL-3.0-or-later |
| `shadow` | 4.20.2-1 | BSD-3-Clause |
| `shared-mime-info` | 2.5.1-1 | GPL-2.0-or-later |
| `slurp` | 1.5.0-1 | MIT |
| `sof-firmware` | 2026.09.2-1 | BSD-3-Clause · LicenseRef-Intel-SOF |
| `spdlog` | 1.17.0-1 | MIT |
| `spirv-headers` | 1.4.357.0-1 | MIT |
| `spirv-llvm-translator` | 22.1.5-1 | NCSA |
| `spirv-tools` | 1.4.357.0-1 | Apache-2.0 |
| `sqlite` | 3.53.4-1 | blessing |
| `sudo` | 1.9.17p2-1 | ISC |
| `systemd` | 261.2-1 | GPL-2.0-or-later · LGPL-2.1-or-later |
| `tar` | 1.35-1 | GPL-3.0-or-later |
| `tcl` | 8.6.18-1 | TCL |
| `texinfo` | 7.3-1 | GPL-3.0-or-later |
| `tllist` | 1.1.0-1 | MIT |
| `tomlplusplus` | 3.4.0-1 | MIT |
| `ttf-dejavu` | 2.37-1 | Bitstream-Vera |
| `ttf-jetbrains-mono-nerd` | 3.5.1-1 | OFL-1.1 · MIT |
| `tuigreet` | 0.11.1-1 | GPL-3.0-only |
| `tzdata` | 2026c-1 | LicenseRef-Public-Domain |
| `util-linux` | 2.42.2-1 | GPL-2.0-or-later · LGPL-2.1-or-later · BSD-3-Clause |
| `vim` | 9.2.1025-1 | Vim |
| `vulkan-headers` | 1.4.357.0-1 | Apache-2.0 OR MIT |
| `vulkan-icd-loader` | 1.4.357.0-1 | Apache-2.0 |
| `waybar` | 0.16.0-2 | MIT |
| `wayland` | 1.26.0-1 | MIT |
| `wayland-protocols` | 1.49-1 | MIT |
| `wget` | 1.25.0-1 | GPL-3.0-or-later |
| `which` | 2.25-1 | GPL-3.0-or-later |
| `wireguard-tools` | 1.0.20260223-1 | GPL-2.0-only |
| `wireless-regdb` | 2026.09.03-1 | ISC |
| `wiremix` | 0.11.0-1 | MIT OR Apache-2.0 |
| `wireplumber` | 0.5.15-1 | MIT |
| `wl-clipboard` | 2.3.0-1 | GPL-3.0-or-later |
| `xcb-proto` | 1.17.0-1 | MIT |
| `xcb-util` | 0.4.1-1 | MIT |
| `xcb-util-cursor` | 0.1.6-1 | MIT |
| `xcb-util-errors` | 1.0.1-1 | MIT |
| `xcb-util-image` | 0.4.1-1 | MIT |
| `xcb-util-keysyms` | 0.4.1-1 | MIT |
| `xcb-util-renderutil` | 0.3.10-1 | MIT |
| `xcb-util-wm` | 0.4.2-1 | MIT |
| `xdg-dbus-proxy` | 0.1.6-1 | LGPL-2.1-or-later |
| `xdg-desktop-portal` | 1.22.1-1 | LGPL-2.1-or-later |
| `xdg-desktop-portal-gtk` | 1.15.3-1 | LGPL-2.1-or-later |
| `xdg-desktop-portal-wlr` | 0.8.4-1 | MIT |
| `xkeyboard-config` | 2.48-1 | MIT |
| `xorg-font-util` | 1.4.2-1 | MIT |
| `xorg-util-macros` | 1.20.2-1 | MIT |
| `xorg-xkbcomp` | 1.5.0-1 | MIT |
| `xorg-xwayland` | 24.1.13-1 | MIT |
| `xorgproto` | 2025.1-1 | MIT |
| `xtrans` | 1.6.0-1 | MIT |
| `xz` | 5.8.3-1 | 0BSD · GPL-2.0-or-later · LGPL-2.1-or-later |
| `zlib` | 1.3.2-1 | Zlib |
| `zsh` | 5.9.2-1 | MIT-Modern-Variant |
| `zsh-autosuggestions` | 0.7.1-1 | MIT |
| `zsh-syntax-highlighting` | 0.8.0-1 | BSD-3-Clause |
| `zstd` | 1.5.7-1 | BSD-3-Clause · GPL-2.0-only |
| `zumo` | 0.3.3-1 | GPL-3.0-or-later |

### Licencias «LicenseRef»

- `LicenseRef-linux-firmware`: varias licencias de fabricantes que permiten redistribuir el firmware (ver WHENCE y LICENSES en el paquete)
- `LicenseRef-Intel-SOF`: licencia de Intel para el firmware de sonido SOF (redistribuible)
- `LicenseRef-Intel-Microcode`: licencia de Intel para el microcódigo (redistribuible sin modificar)
- `LicenseRef-Public-Domain`: dominio público
- `LicenseRef-expect`: licencia propia de Expect (libre, tipo BSD; ver license.terms)
- `LicenseRef-man-pages`: licencias libres variadas de las páginas man (ver el paquete)
