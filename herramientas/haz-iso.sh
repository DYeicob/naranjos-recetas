#!/bin/bash
# NaranjOS — construye la ISO «en vivo» (UEFI, Secure Boot con la MOK de NaranjOS):
#     bash herramientas/haz-iso.sh            (en NaranjOS, como tu usuario; pide sudo)
#     bash herramientas/haz-iso.sh --rapida   aprovecha la raíz de la vez anterior: solo pone al día el arranque y el
#                                             instalador, y vuelve a comprimir (minutos en vez de media hora)
#     bash herramientas/haz-iso.sh --limpia   borra la raíz de trabajo (unos 6 GB) cuando ya no la quieras
# · La raíz de trabajo es un subvolumen Btrfs propio, comprimido con zstd: ocupa la mitad y las «fotos» del
#   sistema NO la guardan dentro (un subvolumen no entra en la foto de @).
# Resultado: ~/naranjos-iso/naranjos-<versión>-x86_64.iso (+ .sha256)
# · La raíz se monta con paquetes de zumo (/srv/zumo/naranjos-core), SIN tus datos: ni usuarios, ni contraseñas,
#   ni WiFi, ni claves (la MOK privada solo se usa aquí para firmar GRUB y el kernel; NO entra en la ISO).
# · Fuera de la ISO (se instalan luego con zumo): NVIDIA, herramientas de ciberseguridad, Rust/Go/mise.
# · En vivo: usuario «naranjos» sin contraseña, entra solo al escritorio; los cambios se pierden al apagar.
set -euo pipefail
O=$'\e[1;38;5;208m'; G=$'\e[1;32m'; R=$'\e[1;31m'; D=$'\e[2m'; Z=$'\e[0m'
say(){ echo "${O}[ISO]${Z} $*"; }
ok(){  echo "${G}  ✔${Z} $*"; }
die(){ echo "${R}[ISO] ERROR:${Z} $*" >&2; exit 1; }
[ "$(id -u)" != 0 ] || die "Sin sudo, por favor (te lo pediré yo)."
cd "$(dirname "$0")/.." || exit 1
DATOS=$PWD/herramientas/iso

VERSION=$(sed -n 's/^VERSION_ID=//p' /etc/os-release | tr -d '"'); VERSION=${VERSION:-0.1}
NOMBRE="naranjos-$VERSION-x86_64"; ETIQUETA=NARANJOS_VIVO
T=/var/tmp/naranjos-iso; RZ=$T/raiz; ISO=$T/iso; SAL=$HOME/naranjos-iso
MOK=/etc/naranjos/mok; SHIM=/usr/share/naranjos/shim; GRUBDIR=/usr/lib/grub/x86_64-efi; ARR=/usr/share/naranjos/arranque
RAPIDA=0; [ "${1:-}" = --rapida ] && RAPIDA=1
# el shim de la ISO: el 16.1 (naranjos-shim16) si está; con él GRUB carga el kernel con el protocolo de carga de
# shim, que funciona en firmwares estrictos (protección de memoria NX). El 15.8 de Ubuntu se queda para el sistema instalado
[ -r /usr/share/naranjos/shim16/shimx64.efi ] && [ -r /usr/share/naranjos/shim16/mmx64.efi ] && SHIM=/usr/share/naranjos/shim16
# la raíz de trabajo: subvolumen Btrfs comprimido (si /var/tmp es Btrfs) o una carpeta normal
BTRFS=0; [ "$(findmnt -no FSTYPE -T /var/tmp 2>/dev/null)" = btrfs ] && command -v btrfs >/dev/null && BTRFS=1
borra_trabajo(){
  [ -e "$T" ] || return 0
  if [ "$BTRFS" = 1 ] && sudo btrfs subvolume show "$T" >/dev/null 2>&1; then
    sudo btrfs subvolume delete "$T" >/dev/null || die "No pude borrar el subvolumen $T (¿algo montado dentro?)"
  else sudo rm -rf "${T:?}"; fi
}
crea_trabajo(){
  if [ "$BTRFS" = 1 ]; then
    sudo btrfs subvolume create "$T" >/dev/null && sudo btrfs property set "$T" compression zstd || die "No pude crear el subvolumen $T"
  else sudo mkdir -p "$T"; fi
  sudo chown "$(id -u):$(id -g)" "$T"   # $T es tuyo (logs); la raíz y la ISO, de root
}
if [ "${1:-}" = --limpia ]; then
  [ -e "$T" ] || { ok "No hay raíz de trabajo que borrar"; exit 0; }
  sudo -v; borra_trabajo; ok "Borrada la raíz de trabajo ($T)"; exit 0
fi
mapfile -t EXCLUIR < <(grep -v '^\s*#' "$DATOS/excluir.txt" | grep -v '^\s*$')

# --- 0. comprobaciones ------------------------------------------------------------------------------
for c in pacman mksquashfs xorriso mkfs.fat sbsign sbverify grub-mkimage; do command -v "$c" >/dev/null || die "Falta $c (lanza la tanda 7b)"; done
for f in "$SHIM/shimx64.efi" "$SHIM/mmx64.efi" "$ARR/sbat.csv"; do [ -r "$f" ] || die "Falta $f"; done
sudo test -r "$MOK/MOK.priv" || die "Falta la clave MOK en $MOK (con ella se firman GRUB y el kernel)"
# lo que dejó una ISO anterior (a medias o no) no cuenta: se borra antes de mirar el sitio libre
if [ "$RAPIDA" = 1 ]; then
  [ -d "$RZ/usr" ] && [ -s "$ISO/naranjos/x86_64/raiz.sfs" ] && [ -s "$T/pacman.conf" ] || die "No hay una ISO anterior que aprovechar: lánzalo sin --rapida"
else
  if [ -e "$T" ]; then say "Borrando la raíz de trabajo anterior ($T)…"; borra_trabajo; sleep 2; fi
  libre=$(df --output=avail -k /var/tmp | tail -n1)
  hace=14; [ "$BTRFS" = 1 ] && hace=9   # comprimida con zstd, la raíz ocupa más o menos la mitad
  [ "$libre" -gt $((hace * 1024 * 1024)) ] || die "Hacen falta unos $hace GB libres en /var/tmp (hay $((libre / 1024 / 1024)) GB): bash herramientas/libera-espacio.sh (y mira «sudo fotos lista»: una foto hecha con la raíz de una ISO vieja dentro la retiene)"
fi
say "NaranjOS $VERSION · ISO en vivo · etiqueta $ETIQUETA"
sudo -v

MONTAJES=()
desmonta(){ local i; for ((i=${#MONTAJES[@]}-1; i>=0; i--)); do sudo umount -l "${MONTAJES[$i]}" 2>/dev/null || true; done; MONTAJES=(); }
trap desmonta EXIT
monta(){ sudo mount "$@"; MONTAJES+=("${!#}"); }
CH(){ sudo chroot "$RZ" /usr/bin/env PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin HOME=/root "$@"; }

pon_instalador(){
  # el instalador: en el menú de aplicaciones (solo en la ISO) y un aviso al entrar
  if [ -x "$RZ/usr/bin/naranjos-instala" ]; then
    printf '[Desktop Entry]\nType=Application\nName=Instalar NaranjOS\nName[en]=Install NaranjOS\nComment=Instala NaranjOS en este equipo\nExec=naranjos-instala\nIcon=system-software-install\nTerminal=false\nCategories=System;\n' \
      | sudo install -Dm644 /dev/stdin "$RZ/usr/share/applications/naranjos-instala.desktop"
    sudo install -d -o 1000 -g 1000 "$RZ/home/naranjos/.config/naranjos"
    printf -- '-- NaranjOS en vivo: aviso de cómo instalarlo\nhl.on("hyprland.start", function() hl.exec_cmd("sleep 4; naranjos-instala --bienvenida") end)\n' \
      | sudo install -m644 -o 1000 -g 1000 /dev/stdin "$RZ/home/naranjos/.config/naranjos/complementos.lua"
  else
    echo "${R}  ! Falta naranjos-instala (lanza la tanda 7c): la ISO saldrá sin instalador${Z}"
  fi
}

if [ "$RAPIDA" = 0 ]; then
# --- 1. la raíz con los paquetes ---------------------------------------------------------------------
borra_trabajo; crea_trabajo
sudo mkdir -p "$RZ" "$ISO"; mkdir -p "$SAL"
sudo mkdir -p "$RZ"/{dev,proc,run,tmp,etc,var/lib/pacman,var/cache/pacman/pkg}
sudo chmod 1777 "$RZ/tmp"
# la forma de la raíz que no es de ningún paquete (LFS): /bin, /sbin, /lib → usr/… y /lib64 con el cargador
# de programas (ld-linux). Sin esto, dentro de la raíz no arranca ningún programa (ni los scripts de pacman)
sin_dueno(){ ! pacman -Qqo "$1" >/dev/null 2>&1; }   # lo que es de un paquete ya lo pondrá pacman
for d in bin sbin lib lib64 usr/lib64; do
  if [ -L "/$d" ]; then
    sudo mkdir -p "$RZ/$(dirname "$d")"; sudo ln -sfn "$(readlink "/$d")" "$RZ/$d"
  elif [ -d "/$d" ]; then
    sudo mkdir -p "$RZ/$d"
    for f in "/$d"/*; do [ -L "$f" ] || [ -f "$f" ] || continue; sin_dueno "$f" && sudo cp -a "$f" "$RZ/$d/"; done
  fi
done
# sin /sys a propósito: así los ganchos que tocan el arranque (EFI) no ven la del equipo y no hacen nada
monta --bind /dev "$RZ/dev"; monta -t proc proc "$RZ/proc"; monta -t tmpfs -o mode=0755 run "$RZ/run"
# pacman.conf del equipo, pero sin documentación ni páginas man (la ISO tiene que caber en 2 GB)
sed -e '/^NoExtract/d' /etc/pacman.conf > "$T/pacman.conf"
sed -i '/^\[options\]/a NoExtract = usr/share/doc/* usr/share/man/* usr/share/info/* usr/share/gtk-doc/*' "$T/pacman.conf"
# firmware que en un PC normal no hace falta (servidores, móviles ARM, y el de nouveau, que NaranjOS bloquea): ~700 MB
FW_FUERA="usr/lib/firmware/qcom/* usr/lib/firmware/nvidia/* usr/lib/firmware/mellanox/* usr/lib/firmware/mrvl/* usr/lib/firmware/qed/* usr/lib/firmware/netronome/* usr/lib/firmware/dpaa2/* usr/lib/firmware/cxgb4/* usr/lib/firmware/liquidio/*"
sed -i "/^\[options\]/a NoExtract = $FW_FUERA" "$T/pacman.conf"
sudo pacman --root "$RZ" --config "$T/pacman.conf" --gpgdir /etc/pacman.d/gnupg -Sy >/dev/null || die "pacman no pudo leer el repositorio naranjos-core"
pacman --root "$RZ" --config "$T/pacman.conf" -Slq | sort -u > "$T/en-repo"
mapfile -t TODO < <(pacman -Qq)
LISTA=(); FALTAN=()
for p in "${TODO[@]}"; do
  printf '%s\n' "${EXCLUIR[@]}" | grep -qxF "$p" && continue
  if grep -qxF "$p" "$T/en-repo"; then LISTA+=("$p"); else FALTAN+=("$p"); fi
done
((${#FALTAN[@]} == 0)) || echo "${R}  ! No están en el repositorio (no entran en la ISO): ${FALTAN[*]}${Z}"
say "Instalando ${#LISTA[@]} paquetes en la raíz de la ISO (de ${#TODO[@]}; fuera: ${#EXCLUIR[@]})…"
sudo pacman --root "$RZ" --config "$T/pacman.conf" --cachedir /var/cache/pacman/pkg --gpgdir /etc/pacman.d/gnupg \
  -Sy --noconfirm --needed "${LISTA[@]}" > "$T/pacman.log" 2>&1 || { tail -30 "$T/pacman.log"; die "pacman falló (log: $T/pacman.log)"; }
for p in "${EXCLUIR[@]}"; do
  if pacman --root "$RZ" -Qq "$p" >/dev/null 2>&1; then
    q=$(LC_ALL=C pacman --root "$RZ" -Qi "$p" 2>/dev/null | sed -n 's/^Required By *: *//p')
    echo "${D}  (entró $p porque lo necesita: ${q:-otro paquete})${Z}"
  fi
done
ok "paquetes instalados ($(sudo du -shx "$RZ" | cut -f1))"

# --- 2. lo que no es de ningún paquete: /etc de NaranjOS (sin nada tuyo ni secreto) -------------------
say "Copiando la configuración de NaranjOS (sin datos personales)…"
pacman -Qlq | sed 's|/$||' | sort -u > "$T/con-dueno"
sudo find /etc /usr -xdev \( -type f -o -type l \) 2>/dev/null | sort > "$T/todo"
comm -13 "$T/con-dueno" "$T/todo" | grep -vEf "$DATOS/no-copiar.txt" > "$T/copiar" || true
# los ficheros de configuración que pacman sabe que cambiaste (los «backup» modificados)
LC_ALL=C pacman -Qii 2>/dev/null | awk '/^MODIFIED/{print $2}' | grep -vEf "$DATOS/no-copiar.txt" >> "$T/copiar" || true
sort -u -o "$T/copiar" "$T/copiar"
sudo rsync -a --files-from="$T/copiar" / "$RZ/" 2>/dev/null || sudo tar -C / -cf - -T "$T/copiar" | sudo tar -C "$RZ" -xf -
ok "$(wc -l < "$T/copiar") ficheros de configuración"
# servicios activados (los enlaces de /etc/systemd): solo los que apuntan a algo que hay en la ISO
sudo find "$RZ/etc/systemd" -xtype l -delete 2>/dev/null || true

# --- 3. usuarios: los del sistema (sin el tuyo) y «naranjos» para la sesión en vivo ------------------
say "Usuarios del sistema y el de la sesión en vivo…"
sudo awk -F: '$3 < 1000 || $3 == 65534' /etc/passwd | sudo tee "$RZ/etc/passwd" >/dev/null
sudo awk -F: -v OFS=: '$3 < 1000 || $3 == 65534 { $4=""; print }' /etc/group | sudo tee "$RZ/etc/group" >/dev/null
sudo awk -F: -v OFS=: 'NR==FNR { u[$1]=1; next } ($1 in u) { $2="!*"; print }' "$RZ/etc/passwd" /etc/shadow | sudo tee "$RZ/etc/shadow" >/dev/null
sudo awk -F: -v OFS=: 'NR==FNR { g[$1]=1; next } ($1 in g) { $2="!*"; $4=""; print }' "$RZ/etc/group" /etc/gshadow | sudo tee "$RZ/etc/gshadow" >/dev/null
sudo sed -i 's/^root:[^:]*:/root:!:/' "$RZ/etc/shadow"
sudo chmod 600 "$RZ/etc/shadow" "$RZ/etc/gshadow"
CH /usr/bin/naranjos-sysusers >/dev/null 2>&1 || true
CH useradd -m -u 1000 -U -G wheel,video,audio,input,storage,plugdev -s /usr/bin/zsh -c "NaranjOS (en vivo)" naranjos 2>/dev/null \
  || CH useradd -m -u 1000 -U -G wheel -s /bin/bash -c "NaranjOS (en vivo)" naranjos
CH passwd -d naranjos >/dev/null
echo 'naranjos ALL=(ALL:ALL) NOPASSWD: ALL' | sudo tee "$RZ/etc/sudoers.d/90-naranjos-vivo" >/dev/null
sudo chmod 440 "$RZ/etc/sudoers.d/90-naranjos-vivo"
printf 'naranjos:100000:65536\n' | sudo tee "$RZ/etc/subuid" "$RZ/etc/subgid" >/dev/null
ok "usuario «naranjos» (sin contraseña; sudo sin preguntar, solo en la ISO)"

# --- 4. la sesión en vivo: entra sola al escritorio --------------------------------------------------
say "Ajustes de la sesión en vivo…"
echo naranjos-vivo | sudo tee "$RZ/etc/hostname" >/dev/null
sudo truncate -s 0 "$RZ/etc/machine-id"
printf '# NaranjOS en vivo: la raíz la monta el initramfs (naranjos.vivo=…)\n' | sudo tee "$RZ/etc/fstab" >/dev/null
if [ -f "$RZ/etc/greetd/config.toml" ]; then
  sudo sed -i '/^\[initial_session\]/,/^\[/{/^\[initial_session\]/d;/^command/d;/^user/d}' "$RZ/etc/greetd/config.toml"
  printf '\n[initial_session]\ncommand = "%s"\nuser = "naranjos"\n' "$(command -v naranjos-sesion || echo Hyprland)" \
    | sudo tee -a "$RZ/etc/greetd/config.toml" >/dev/null
fi
pon_instalador
sudo install -Dm644 "$DATOS/naranjos-llavero.service" "$RZ/etc/systemd/system/naranjos-llavero.service"
sudo mkdir -p "$RZ/etc/systemd/system/multi-user.target.wants"
sudo ln -sf ../naranjos-llavero.service "$RZ/etc/systemd/system/multi-user.target.wants/naranjos-llavero.service"
sudo rm -rf "$RZ/etc/pacman.d/gnupg"             # cada equipo crea su propio llavero al arrancar
# el sistema que salga de la ISO tampoco instala documentación (como la ISO): mismo NoExtract
sudo sed -i -e '/^NoExtract/d' -e '/^\[options\]/a NoExtract = usr/share/doc/* usr/share/man/* usr/share/info/* usr/share/gtk-doc/*' "$RZ/etc/pacman.conf"
sudo sed -i "/^\[options\]/a # firmware fuera de la ISO (si tu PC lo necesita: borra esta línea y reinstala linux-firmware)\nNoExtract = $FW_FUERA" "$RZ/etc/pacman.conf"
sudo rm -f "$RZ"/etc/ssh/ssh_host_* "$RZ/var/lib/systemd/random-seed"
sudo rm -rf "$RZ/var/cache/pacman/pkg"/* "$RZ/var/lib/pacman/sync"/* "$RZ/var/log"/* "$RZ/root/.bash_history"
ok "greetd entra solo como «naranjos»; llavero de pacman nuevo en cada arranque"

else
  say "Modo rápido: se aprovecha la raíz de la vez anterior (solo se ponen al día el arranque y el instalador)"
  monta --bind /dev "$RZ/dev"; monta -t proc proc "$RZ/proc"; monta -t tmpfs -o mode=0755 run "$RZ/run"
  sudo pacman --root "$RZ" --config "$T/pacman.conf" --cachedir /var/cache/pacman/pkg --gpgdir /etc/pacman.d/gnupg \
    -Sy --noconfirm --needed naranjos-initramfs naranjos-arranque naranjos-shim16 naranjos-instalador > "$T/pacman-rapida.log" 2>&1 \
    || { tail -20 "$T/pacman-rapida.log"; die "pacman falló"; }
  ok "$(pacman --root "$RZ" -Q naranjos-initramfs naranjos-arranque naranjos-instalador 2>/dev/null | tr '\n' ' ')"
  pon_instalador
fi

# --- 5. cachés y el arranque de la ISO ---------------------------------------------------------------
say "Preparando cachés, initramfs y kernel firmado…"
K=$(ls "$RZ/usr/lib/modules" | head -n1)
CH /bin/bash -c "ldconfig; depmod -a '$K'; update-mime-database /usr/share/mime >/dev/null 2>&1; \
  glib-compile-schemas /usr/share/glib-2.0/schemas 2>/dev/null; gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor 2>/dev/null; \
  fc-cache -s >/dev/null 2>&1; systemd-tmpfiles --create >/dev/null 2>&1; true"
CH /usr/bin/naranjos-kernel instala >/dev/null 2>&1 || true
[ -e "$RZ/boot/vmlinuz-linux-naranjos" ] || sudo cp "$RZ/usr/lib/modules/$K/vmlinuz" "$RZ/boot/vmlinuz-linux-naranjos"
printf 'MODULOS="isofs squashfs overlay loop sr_mod cdrom usb_storage uas"\nMICROCODIGO=todos\n' | sudo tee "$RZ/etc/naranjos/initramfs.conf" >/dev/null
CH /usr/bin/naranjos-initramfs --todos > "$T/initramfs.log" 2>&1 || { tail -20 "$T/initramfs.log"; die "No pude hacer el initramfs"; }
sudo mkdir -p "$ISO/boot/grub" "$ISO/naranjos/x86_64"
sudo sbsign --key "$MOK/MOK.priv" --cert "$MOK/MOK.pem" --output "$ISO/boot/vmlinuz-linux-naranjos" "$RZ/boot/vmlinuz-linux-naranjos" >/dev/null 2>&1 \
  || die "No pude firmar el kernel"
sudo sbverify --cert "$MOK/MOK.pem" "$ISO/boot/vmlinuz-linux-naranjos" >/dev/null 2>&1 || die "La firma del kernel no se verifica"
sudo cp "$RZ/boot/initramfs-linux-naranjos.img" "$ISO/boot/"
ok "kernel $K firmado con la MOK e initramfs con el modo en vivo"

# --- 6. la raíz comprimida ---------------------------------------------------------------------------
desmonta; trap - EXIT
if :; then   # también con --rapida: el instalador y el arranque cambian dentro de la raíz
  say "Comprimiendo la raíz (squashfs + xz; unos minutos)…"
  sudo mksquashfs "$RZ" "$ISO/naranjos/x86_64/raiz.sfs" -comp xz -Xbcj x86 -b 1M -noappend -no-progress -quiet \
    -e boot/initramfs-linux-naranjos.img > /dev/null
fi
ok "raiz.sfs: $(du -h "$ISO/naranjos/x86_64/raiz.sfs" | cut -f1)"

# --- 7. GRUB firmado y la partición EFI de la ISO ----------------------------------------------------
say "GRUB firmado y partición EFI…"
GD=$T/grub; mkdir -p "$GD/md/fonts"
printf 'search --no-floppy --label %s --set=root\nset prefix=($root)/boot/grub\nconfigfile $prefix/grub.cfg\necho "NaranjOS: no encuentro el medio %s"\nsleep 15\n' "$ETIQUETA" "$ETIQUETA" > "$GD/inicio.cfg"
cp "$ARR"/fuentes/*.pf2 "$GD/md/fonts/" 2>/dev/null || true
tar -C "$GD/md" -cf "$GD/memdisk.tar" fonts
MODS="part_gpt part_msdos fat iso9660 normal boot linux chain configfile search search_label search_fs_uuid search_fs_file
echo test true sleep reboot halt efi_gop efi_uga all_video video_fb gzio minicmd ls cat help efifwsetup regexp gfxterm font memdisk tar"
# shellcheck disable=SC2086
grub-mkimage -O x86_64-efi -d "$GRUBDIR" -p /boot/grub -c "$GD/inicio.cfg" --sbat "$ARR/sbat.csv" -m "$GD/memdisk.tar" \
  -o "$GD/grubx64.sinfirmar" $MODS || die "grub-mkimage falló"
sudo sbsign --key "$MOK/MOK.priv" --cert "$MOK/MOK.pem" --output "$GD/grubx64.efi" "$GD/grubx64.sinfirmar" >/dev/null 2>&1 || die "No pude firmar GRUB"
sed -e "s/@ETIQUETA@/$ETIQUETA/g" -e "s/@VERSION@/$VERSION/g" "$DATOS/grub.cfg" | sudo tee "$ISO/boot/grub/grub.cfg" >/dev/null
# la partición EFI (FAT) que lleva dentro la ISO: shim → GRUB firmado; MokManager y la clave pública de NaranjOS
EFI=$T/efiboot.img; truncate -s 16M "$EFI"; mkfs.fat -n NARANJOSEFI "$EFI" >/dev/null
mkdir -p "$T/efi"; sudo mount -o loop "$EFI" "$T/efi"
sudo mkdir -p "$T/efi/EFI/BOOT"
sudo cp "$SHIM/shimx64.efi" "$T/efi/EFI/BOOT/BOOTX64.EFI"
sudo cp "$SHIM/mmx64.efi" "$T/efi/EFI/BOOT/mmx64.efi"
sudo cp "$GD/grubx64.efi" "$T/efi/EFI/BOOT/grubx64.efi"
sudo cp "$MOK/MOK.der" "$T/efi/NARANJOS-MOK.der"           # la clave PÚBLICA: para registrarla en MokManager
sudo umount "$T/efi"
sudo cp "$MOK/MOK.der" "$ISO/NARANJOS-MOK.der"
sudo install -Dm644 "$DATOS/LEEME.txt" "$ISO/LEEME.txt"
case "$SHIM" in */shim16) ok "shim 16.1 (Debian/Microsoft) → GRUB firmado con la MOK de NaranjOS" ;;
  *) ok "shim 15.8 (Canonical/Microsoft) → GRUB firmado con la MOK de NaranjOS"
     echo "${D}  (con el shim 15.8, en firmwares estrictos la ISO se queda en «Arrancando NaranjOS…» con Secure Boot: instala naranjos-shim16)${Z}" ;; esac

# --- 8. la ISO híbrida (DVD y USB) -------------------------------------------------------------------
say "Escribiendo la ISO…"
rm -f "$SAL/$NOMBRE.iso" "$SAL/$NOMBRE.iso.sha256"
sudo xorriso -as mkisofs -iso-level 3 -full-iso9660-filenames -joliet -joliet-long -rational-rock \
  -volid "$ETIQUETA" -appid "NaranjOS $VERSION" -publisher "NaranjOS" -preparer "naranjos haz-iso.sh" \
  -partition_offset 16 -append_partition 2 C12A7328-F81F-11D2-BA4B-00A0C93EC93B "$EFI" -appended_part_as_gpt \
  -eltorito-alt-boot -e --interval:appended_partition_2:all:: -no-emul-boot \
  -output "$SAL/$NOMBRE.iso" "$ISO" > "$T/xorriso.log" 2>&1 || { tail -20 "$T/xorriso.log"; die "xorriso falló"; }
sudo chown "$(id -u):$(id -g)" "$SAL/$NOMBRE.iso"
(cd "$SAL" && sha256sum "$NOMBRE.iso" > "$NOMBRE.iso.sha256")
TAM=$(stat -c %s "$SAL/$NOMBRE.iso")
ok "$SAL/$NOMBRE.iso  ($(numfmt --to=iec "$TAM"))"
if [ "$TAM" -ge 2147483648 ]; then
  echo "${R}  ! Pasa de 2 GB: GitHub no la aceptará en un solo archivo. Lo que más ocupa dentro:${Z}"
  sudo du -sh "$RZ"/usr/lib/firmware "$RZ"/usr/lib/llvm* "$RZ"/usr/libexec/gcc "$RZ"/usr/lib/gcc "$RZ"/usr/share/{fonts,icons,naranjos} 2>/dev/null | sort -rh | head
fi
echo "${D}  (la raíz de trabajo queda en $T para --rapida; bórrala con: bash herramientas/haz-iso.sh --limpia)${Z}"
