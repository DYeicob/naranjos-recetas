#!/bin/bash
# NaranjOS — instala zumo 0.2.0 y prueba 'zumo exprime' (ejecutar como yeicob, sin sudo)
set -euo pipefail
O=$'\e[0;33m'; G=$'\e[1;32m'; R=$'\e[1;31m'; Z=$'\e[0m'
say(){ echo "${O}[NaranjOS]${Z} $*"; }
die(){ echo "${R}[NaranjOS] ERROR:${Z} $*"; exit 1; }
[ "$(id -u)" != 0 ] || die "Sin sudo, por favor."
REC=$HOME/naranjos-recetas; REPO=/srv/zumo/naranjos-core; DB=$REPO/naranjos-core.db.tar.zst
export GPG_TTY=$(tty)
sudo -v
say "1/3 Construyendo zumo 0.2.0 a mano (la última vez que se hace así)…"
cd "$REC/zumo"
PKGDEST=$REPO makepkg -f --sign
mapfile -t P < <(PKGDEST=$REPO makepkg --packagelist)
repo-add --sign --verify --remove "$DB" "${P[@]}"
rm -rf src pkg
sudo pacman -Sy --noconfirm zumo
say "2/3 Primera prueba de 'zumo exprime': pacman 7.1.0-2 (descarga su fuente de Debian)…"
zumo exprime pacman
say "3/3 zumo actualiza…"
zumo actualiza
echo
zumo version
grep -A3 '^\[naranjos-core\]' /etc/pacman.conf
echo "${G}Fase 5.0 lista.${Z}"
