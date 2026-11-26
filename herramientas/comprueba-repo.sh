#!/bin/bash
# NaranjOS — ¿está al día el repositorio de internet (la Release «naranjos-core» de GitHub)?   (en NaranjOS)
#     bash herramientas/comprueba-repo.sh
# Compara lo que hay en /srv/zumo/naranjos-core (tu equipo) con lo publicado en GitHub, que es de donde se
# actualizan los equipos instalados con la ISO. Solo lee: no cambia nada.
set -uo pipefail
O=$'\e[1;38;5;208m'; G=$'\e[1;32m'; R=$'\e[1;31m'; A=$'\e[1;33m'; Z=$'\e[0m'
URL=https://github.com/DYeicob/naranjos-recetas/releases/download/naranjos-core
LOCAL=/srv/zumo/naranjos-core/naranjos-core.db
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
[ -r "$LOCAL" ] || { echo "${R}No encuentro $LOCAL${Z}"; exit 1; }
echo "${O}NaranjOS · repositorio en internet${Z}"
curl -fsSL --retry 3 -o "$T/web.db" "$URL/naranjos-core.db" || { echo "${R}No pude descargar $URL/naranjos-core.db (¿internet? ¿publicado alguna vez?)${Z}"; exit 1; }
lista(){ bsdtar -tf "$1" 2>/dev/null | sed -n 's|/$||p' | sort -u; }
lista "$LOCAL" > "$T/aqui"; lista "$T/web.db" > "$T/web"
faltan=$(comm -23 "$T/aqui" "$T/web"); sobran=$(comm -13 "$T/aqui" "$T/web")
echo "  En tu equipo: $(wc -l < "$T/aqui") paquetes · en GitHub: $(wc -l < "$T/web")"
if [ -z "$faltan" ]; then
  echo "${G}✔${Z} GitHub está al día: los equipos instalados reciben todo lo tuyo."
else
  echo "${A}!${Z} En GitHub faltan o están viejos $(echo "$faltan" | wc -l) paquetes, p. ej.:"; echo "$faltan" | head -15 | sed 's/^/    /'
  echo "  Para publicarlos: aquí  bash herramientas/fuentes.sh  y en Ubuntu  sudo bash hito1-montaje.sh  y  bash naranjos-github.sh"
fi
[ -n "$sobran" ] && { echo "  (en GitHub hay $(echo "$sobran" | wc -l) versiones que aquí ya no: se quitarán al publicar)"; }
exit 0
