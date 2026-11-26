#!/bin/bash
# NaranjOS — libera espacio en disco antes de construir la ISO:  bash herramientas/libera-espacio.sh
# Primero ENSEÑA lo que se puede borrar y cuánto ocupa; solo borra si escribes SI.
# No toca: /home salvo restos de compilación y cachés, los paquetes instalados, las fotos del sistema,
# ni los paquetes «huérfanos» (muchos son herramientas para compilar las tandas que vienen).
set -uo pipefail
O=$'\e[1;38;5;208m'; G=$'\e[1;32m'; D=$'\e[2m'; Z=$'\e[0m'
[ "$(id -u)" != 0 ] || { echo "Sin sudo, por favor (te lo pediré cuando haga falta)."; exit 1; }
cd "$(dirname "$0")/.." || exit 1
REC=$PWD
tam(){ du -shc "$@" 2>/dev/null | tail -n1 | cut -f1; }
libre(){ df -h --output=avail / | tail -n1 | tr -d ' '; }

mapfile -t RESTOS < <(find "$REC" -mindepth 2 -maxdepth 2 \( -name src -o -name pkg \) -type d 2>/dev/null; \
                      find "$REC" -mindepth 2 -maxdepth 2 -name '*.pkg.tar.*' 2>/dev/null)
CACHES=(); for c in "$HOME/.cache/go-build" "$HOME/go/pkg/mod" "$HOME/.cache/pip" "$HOME/.cargo/registry" "$HOME/.npm/_cacache"; do
  [ -e "$c" ] && CACHES+=("$c"); done

echo "${O}NaranjOS · liberar espacio${Z}   (libre ahora en /: $(libre))"
echo
printf '  %-46s %s\n' "Restos de compilación de las recetas (src/, pkg/)" "$( ((${#RESTOS[@]})) && tam "${RESTOS[@]}" || echo 0)"
printf '  %-46s %s\n' "Cachés de Go, pip, Cargo y npm"                    "$( ((${#CACHES[@]})) && tam "${CACHES[@]}" || echo 0)"
printf '  %-46s %s\n' "Caché de pacman (versiones antiguas)"               "$(tam /var/cache/pacman/pkg)"
printf '  %-46s %s\n' "Diario del sistema (se deja en 200 MB)"            "$(journalctl --disk-usage 2>/dev/null | grep -o '[0-9.]*[KMGT]' | head -n1)"
command -v flatpak >/dev/null && printf '  %-46s %s\n' "Flatpak: lo que ya no usa ninguna app" "(lo calcula flatpak)"
command -v fotos >/dev/null && printf '  %-46s %s\n' "Fotos: restos de «fotos vuelve» (@.viejo-*)" "(las fotos en sí se quedan)"
[ -e /var/lib/naranjos/kernel-7.1.8-naranjos.tar.zst ] && \
  printf '  %s(no se toca) copia del kernel 7.1.8: %s en /var/lib/naranjos/ — bórrala tú si ya no la quieres%s\n' "$D" "$(tam /var/lib/naranjos/kernel-7.1.8-naranjos.tar.zst)" "$Z"
echo
read -rp "Escribe SI para borrar todo eso: " r; [ "$r" = SI ] || { echo "No se ha borrado nada."; exit 0; }

antes=$(libre)
if ((${#RESTOS[@]})); then chmod -R u+w "${RESTOS[@]}" 2>/dev/null; rm -rf "${RESTOS[@]}"; fi   # Go deja sus módulos en solo lectura
if ((${#CACHES[@]})); then chmod -R u+w "${CACHES[@]}" 2>/dev/null; rm -rf "${CACHES[@]}"; fi
sudo pacman -Sc --noconfirm >/dev/null
sudo journalctl --vacuum-size=200M >/dev/null 2>&1
command -v flatpak >/dev/null && { flatpak uninstall --unused -y >/dev/null 2>&1; sudo flatpak uninstall --system --unused -y >/dev/null 2>&1; }
command -v fotos >/dev/null && sudo fotos limpia >/dev/null 2>&1
sync
echo "${G}✔${Z} Hecho. Libre en /: antes ${antes}, ahora $(libre)  ${D}(en Btrfs puede tardar unos segundos en notarse)${Z}"
