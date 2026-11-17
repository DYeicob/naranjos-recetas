#!/bin/bash
# NaranjOS — construye una tanda de recetas en orden:  bash herramientas/tanda.sh 5a1
# Salta lo que ya está instalado en la misma versión; se para en el primer fallo.
set -uo pipefail
O=$'\e[0;33m'; G=$'\e[1;32m'; R=$'\e[1;31m'; Z=$'\e[0m'
[ "$(id -u)" != 0 ] || { echo "Sin sudo, por favor."; exit 1; }
cd "$(dirname "$0")/.."
L="herramientas/tanda-${1:?Dime la tanda, p.ej. 5a1}.txt"
[ -s "$L" ] || { echo "${R}No existe $L${Z}"; exit 1; }
# que la contraseña de la clave y de sudo duren toda la tanda
grep -q '^default-cache-ttl' ~/.gnupg/gpg-agent.conf 2>/dev/null || {
  printf 'default-cache-ttl 7200\nmax-cache-ttl 28800\n' >> ~/.gnupg/gpg-agent.conf; gpgconf --kill gpg-agent; }
export GPG_TTY=$(tty)
# makepkg quiere PACKAGER con formato "Nombre <correo>" (correo ficticio .invalid)
grep -q '^PACKAGER=' ~/.makepkg.conf 2>/dev/null || echo 'PACKAGER="NaranjOS Packager <yeicob@naranjos.invalid>"' >> ~/.makepkg.conf
zumo ayuda | grep -q -- '-y' || { echo "${R}Necesitas zumo 0.2.1:  zumo exprime -i zumo${Z}"; exit 1; }
total=$(grep -c . "$L"); i=0; inicio=$SECONDS
while read -r r <&3; do
  [ -n "$r" ] || continue; i=$((i+1))
  ver=$(cd "$r" && makepkg --printsrcinfo | awk '/^\tpkgver = /{v=$3} /^\tpkgrel = /{r=$3} END{print v"-"r}')
  if [ "$(pacman -Q "$r" 2>/dev/null | cut -d' ' -f2)" = "$ver" ]; then
    echo "${O}[$i/$total]${Z} $r $ver ya instalado, se salta"; continue
  fi
  echo "${O}[$i/$total]${Z} ${r} ${ver}"
  zumo exprime -i -y "$r" || { echo "${R}Falló '$r'. Corrígelo y vuelve a lanzar la tanda: seguirá desde aquí.${Z}"; exit 1; }
done 3< "$L"
echo "${G}Tanda ${1} completa en $(( (SECONDS-inicio)/60 )) min.${Z}"
