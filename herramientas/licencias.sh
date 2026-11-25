#!/bin/bash
# NaranjOS — saca los textos de licencia de los .src.tar.gz (fase 6i)
#   bash herramientas/licencias.sh <carpeta-destino> <receta-versión.src.tar.gz>…
# Por cada .src.tar.gz deja <destino>/<receta>/ con los COPYING, LICENSE, license.terms… de su fuente
# original (en la raíz de la fuente, en LICENSES/ o sin carpeta de primer nivel) y <receta>/.version.
# Lo usan herramientas/fuentes.sh (NaranjOS) y naranjos-tanda-6i2.sh (Ubuntu).
set -uo pipefail
[ $# -ge 2 ] || { echo "Uso: licencias.sh <destino> <fichero.src.tar.gz>…"; exit 1; }
command -v bsdtar >/dev/null || { echo "Falta bsdtar (en Ubuntu: sudo apt install libarchive-tools)"; exit 1; }
DEST=$1; shift
mkdir -p "$DEST"
# nombre de fichero de licencia (sin distinguir mayúsculas)
NOMBRE='(copying|copyright|licen[cs]e|notice|unlicense|whence|artistic|license\.terms|lgpl|gpl|ofl|mpl)[^/]*'
PATRON="^([^/]+/)?(doc/)?($NOMBRE|(licenses|licences)/[^/]+)$"
for s in "$@"; do
  f=${s##*/}; f=${f%.src.tar.gz}
  base=${f%-*}; base=${base%-*}; ver=${f#"$base"-}
  t=$(mktemp -d)
  bsdtar -xf "$s" -C "$t" 2>/dev/null || { echo "! no puedo abrir $s"; rm -rf "$t"; continue; }
  rm -rf "${DEST:?}/$base"; mkdir -p "$DEST/$base" "$t/x"
  for a in "$t/$base"/*; do
    case "$a" in
      *.tar|*.tar.*|*.tgz|*.tbz2|*.txz|*.zip|*.whl) ;;
      *) continue ;;
    esac
    bsdtar -tf "$a" 2>/dev/null | grep -iE "$PATRON" | grep -v '/$' | head -n 80 > "$t/lista" || true
    [ -s "$t/lista" ] || continue
    bsdtar -xf "$a" -C "$t/x" -T "$t/lista" 2>/dev/null || true
  done
  ( cd "$t/x" && find . -type f -size -2M -printf '%P\n' ) | while read -r x; do
    # se quita la carpeta de primer nivel de la fuente (p. ej. «glib-2.88.3/»), si la hay
    case "$x" in */*) r=${x#*/} ;; *) r=$x ;; esac
    case "$r" in */*) d="$DEST/$base/${r%/*}" ;; *) d="$DEST/$base" ;; esac
    mkdir -p "$d"; cp "$t/x/$x" "$d/" 2>/dev/null || true
  done
  echo "$ver" > "$DEST/$base/.version"
  rm -rf "$t"
done
