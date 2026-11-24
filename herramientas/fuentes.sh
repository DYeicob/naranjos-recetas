#!/bin/bash
# NaranjOS — fase 6i: el código fuente de cada paquete (GPL) y los textos de sus licencias
#   bash herramientas/fuentes.sh            (en NaranjOS, con tu usuario, SIN sudo)
# Por cada receta con paquete en el repo (/srv/zumo/naranjos-core):
#   · /srv/zumo/naranjos-fuentes/<receta>-<versión>.src.tar.gz  (makepkg --allsource: receta + parches + fuente original)
#   · /srv/zumo/naranjos-fuentes/licencias/<receta>/…            (COPYING, LICENSE… sacados de la fuente original)
# Salta lo que ya está hecho en la misma versión y borra las versiones viejas. Luego, en Ubuntu,
# naranjos-github.sh lo publica en la Release «naranjos-fuentes».
set -uo pipefail
O=$'\e[1;38;5;208m'; G=$'\e[1;32m'; R=$'\e[1;31m'; A=$'\e[1;33m'; Z=$'\e[0m'
[ "$(id -u)" != 0 ] || { echo "Sin sudo, por favor."; exit 1; }
cd "$(dirname "$0")/.." || exit 1
REPO=${ZUMO_REPO:-/srv/zumo/naranjos-core}
FU=${NARANJOS_FUENTES:-/srv/zumo/naranjos-fuentes}
LIC=$FU/licencias
[ -d "$REPO" ] || { echo "${R}No encuentro el repositorio $REPO${Z}"; exit 1; }
command -v bsdtar >/dev/null || { echo "${R}Falta bsdtar (libarchive)${Z}"; exit 1; }
if [ ! -d "$FU" ]; then sudo install -d -o "$(id -un)" -g "$(id -gn)" -m 755 "$FU" || exit 1; fi
mkdir -p "$LIC" || exit 1
# si ~/.makepkg.conf tiene SRCDEST, las fuentes descargadas están allí y no en cada receta
SD=$( . /etc/makepkg.conf 2>/dev/null; [ -r ~/.makepkg.conf ] && . ~/.makepkg.conf; echo "${SRCDEST:-}" )
# patrones de los ficheros de licencia (en la raíz de la fuente, o en LICENSES/ o licenses/)
PATRON='^[^/]+/((COPYING|COPYRIGHT|LICEN[CS]E|NOTICE|UNLICENSE|WHENCE)[^/]*|(LICENSES|licenses|LICENCES)/[^/]+|LICENCE\.[^/]+)$'

fallos=(); hechas=0; saltadas=0; total=0; inicio=$SECONDS
mapfile -t todas < <(ls -d */ | tr -d / | while read -r r; do [ -f "$r/PKGBUILD" ] && echo "$r"; done)
: > "$LIC/.indice.nuevo"
for r in "${todas[@]}"; do
  info=$(cd "$r" && makepkg --printsrcinfo 2>/dev/null) || { fallos+=("$r (receta)"); continue; }
  base=$(awk '/^pkgbase = /{print $3; exit}' <<< "$info")
  ver=$(awk '/^\tepoch = /{e=$3":"} /^\tpkgver = /{v=$3} /^\tpkgrel = /{r=$3} END{print e v "-" r}' <<< "$info")
  lic=$(awk '/^\tlicense = /{printf "%s ", $3}' <<< "$info")
  # ¿tiene paquete en el repositorio?
  pk=$(awk '/^pkgname = /{print $3}' <<< "$info" | while read -r n; do ls "$REPO/$n-$ver-"*.pkg.tar.zst 2>/dev/null; done | head -n1)
  [ -n "$pk" ] || continue
  total=$((total + 1))
  printf '%s\t%s\t%s\n' "$base" "$ver" "${lic% }" >> "$LIC/.indice.nuevo"
  f="$FU/$base-$ver.src.tar.gz"
  if [ -s "$f" ] && [ -e "$LIC/$base/.version" ] && [ "$(cat "$LIC/$base/.version")" = "$ver" ]; then
    saltadas=$((saltadas + 1)); continue
  fi
  echo "${O}[$total]${Z} $base $ver"
  if [ ! -s "$f" ]; then
    if ! ( cd "$r" && SRCPKGDEST="$FU" makepkg --allsource -f >/dev/null 2>"$FU/.error-$base" ); then
      fallos+=("$base (mira $FU/.error-$base)"); continue
    fi
    rm -f "$FU/.error-$base"
  fi
  # versiones viejas de la misma receta
  for v in "$FU/$base"-[0-9]*.src.tar.gz; do
    [ -e "$v" ] && [ "$v" != "$f" ] && [[ "${v#"$FU/$base"-}" =~ ^[0-9][^/]*-[0-9.]+\.src\.tar\.gz$ ]] && rm -f "$v"
  done
  # textos de licencia sacados de cada fuente original de la receta
  rm -rf "${LIC:?}/$base"; mkdir -p "$LIC/$base"
  t=$(mktemp -d)
  while read -r s; do
    s=${s%%::*}; s=${s##*/}; a="$r/$s"
    [ -f "$a" ] || a="$SD/$s"
    [ -f "$a" ] || continue
    case "$a" in *.tar|*.tar.*|*.tgz|*.tbz2|*.txz|*.zip) ;; *) continue ;; esac
    bsdtar -tf "$a" 2>/dev/null | grep -E "$PATRON" | head -n 60 > "$t/lista" || true
    [ -s "$t/lista" ] || continue
    bsdtar -xf "$a" -C "$t" -T "$t/lista" 2>/dev/null || true
  done < <(awk '/^\tsource = /{print $3}' <<< "$info")
  ( cd "$t" && find . -type f -size -2M ! -name lista -printf '%P\n' ) | while read -r x; do
    d="$LIC/$base/$(dirname "${x#*/}")"; mkdir -p "$d"; cp "$t/$x" "$d/"
  done
  rm -rf "$t"
  echo "$ver" > "$LIC/$base/.version"
  hechas=$((hechas + 1))
done
mv -f "$LIC/.indice.nuevo" "$LIC/INDICE.tsv"
# licencias de recetas que ya no están
for d in "$LIC"/*/; do d=${d%/}; awk -F'\t' -v b="${d##*/}" '$1==b{f=1} END{exit !f}' "$LIC/INDICE.tsv" || rm -rf "$d"; done
sin=$(for d in "$LIC"/*/; do case "$d" in */naranjos-*/|*/zumo/) continue ;; esac
       [ -n "$(find "$d" -type f ! -name .version | head -n1)" ] || basename "$d"; done | tr '\n' ' ')
echo
echo "${G}Fuentes: $hechas nuevas, $saltadas ya estaban, $total recetas con paquete · $(du -sh "$FU" | cut -f1) en $FU · $(( (SECONDS-inicio)/60 )) min${Z}"
[ -n "$sin" ] && echo "${A}Sin texto de licencia en la fuente (lo revisa Claude):${Z} $sin"
if [ ${#fallos[@]} -gt 0 ]; then
  echo "${R}Fallaron ${#fallos[@]}:${Z}"; printf '  %s\n' "${fallos[@]}"; exit 1
fi
echo "Siguiente: en Ubuntu,  bash ~/naranjos-workspace/naranjos-github.sh  (publica la Release naranjos-fuentes)"
