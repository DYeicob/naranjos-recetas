#!/bin/bash
# NaranjOS — construye la ISO «en vivo» (UEFI, Secure Boot con la MOK de NaranjOS):
#     bash herramientas/haz-iso.sh            (en NaranjOS, como tu usuario; pide sudo)
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
mapfile -t EXCLUIR < <(grep -v '^\s*#' "$DATOS/excluir.txt" | grep -v '^\s*$')

# --- 0. comprobaciones ------------------------------------------------------------------------------
for c in pacman mksquashfs xorriso mkfs.fat sbsign sbverify grub-mkimage; do command -v "$c" >/dev/null || die "Falta $c (lanza la tanda 7b)"; done
for f in "$SHIM/shimx64.efi" "$SHIM/mmx64.efi" "$ARR/sbat.csv"; do [ -r "$f" ] || die "Falta $f"; done
sudo test -r "$MOK/MOK.priv" || die "Falta la clave MOK en $MOK (con ella se firman GRUB y el kernel)"
libre=$(df --output=avail -k /var/tmp | tail -n1)
[ "$libre" -gt $((14 * 1024 * 1024)) ] || die "Hacen falta unos 14 GB libres en /var/tmp (hay $((libre / 1024 / 1024)) GB): bash herramientas/libera-espacio.sh"
say "NaranjOS $VERSION · ISO en vivo · etiqueta $ETIQUETA"
sudo -v

MONTAJES=()
desmonta(){ local i; for ((i=${#MONTAJES[@]}-1; i>=0; i--)); do sudo umount -l "${MONTAJES[$i]}" 2>/dev/null || true; done; MONTAJES=(); }
trap desmonta EXIT
monta(){ sudo mount "$@"; MONTAJES+=("${!#}"); }

# --- 1. la raíz con los paquetes ---------------------------------------------------------------------
sudo rm -rf "$T"; sudo mkdir -p "$T"; sudo chown "$(id -u):$(id -g)" "$T"   # $T es tuyo (logs); la raíz y la ISO, de root
sudo mkdir -p "$RZ" "$ISO"; mkdir -p "$SAL"
sudo mkdir -p "$RZ"/{dev,proc,run,tmp,etc,var/lib/pacman,var/cache/pacman/pkg}
sudo chmod 1777 "$RZ/tmp"
# sin /sys a propósito: así los ganchos que tocan el arranque (EFI) no ven la del equipo y no hacen nada
monta --bind /dev "$RZ/dev"; monta -t proc proc "$RZ/proc"; monta -t tmpfs -o mode=0755 run "$RZ/run"
# pacman.conf del equipo, pero sin documentación ni páginas man (la ISO tiene que caber en 2 GB)
sed -e '/^NoExtract/d' /etc/pacman.conf > "$T/pacman.conf"
sed -i '/^\[options\]/a NoExtract = usr/share/doc/* usr/share/man/* usr/share/info/* usr/share/gtk-doc/*' "$T/pacman.conf"
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
  pacman --root "$RZ" -Qq "$p" >/dev/null 2>&1 && echo "${D}  (entró $p porque otro paquete lo necesita)${Z}"
done
ok "paquetes instalados ($(sudo du -sh "$RZ" | cut -f1))"

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
sudo chroot "$RZ" /usr/bin/naranjos-sysusers >/dev/null 2>&1 || true
sudo chroot "$RZ" useradd -m -u 1000 -U -G wheel,video,audio,input,storage,plugdev -s /usr/bin/zsh -c "NaranjOS (en vivo)" naranjos 2>/dev/null \
  || sudo chroot "$RZ" useradd -m -u 1000 -U -G wheel -s /bin/bash -c "NaranjOS (en vivo)" naranjos
sudo chroot "$RZ" passwd -d naranjos >/dev/null
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
sudo install -Dm644 "$DATOS/naranjos-llavero.service" "$RZ/etc/systemd/system/naranjos-llavero.service"
sudo mkdir -p "$RZ/etc/systemd/system/multi-user.target.wants"
sudo ln -sf ../naranjos-llavero.service "$RZ/etc/systemd/system/multi-user.target.wants/naranjos-llavero.service"
sudo rm -rf "$RZ/etc/pacman.d/gnupg"             # cada equipo crea su propio llavero al arrancar
# el sistema que salga de la ISO tampoco instala documentación (como la ISO): mismo NoExtract
sudo sed -i -e '/^NoExtract/d' -e '/^\[options\]/a NoExtract = usr/share/doc/* usr/share/man/* usr/share/info/* usr/share/gtk-doc/*' "$RZ/etc/pacman.conf"
sudo rm -f "$RZ"/etc/ssh/ssh_host_* "$RZ/var/lib/systemd/random-seed"
sudo rm -rf "$RZ/var/cache/pacman/pkg"/* "$RZ/var/lib/pacman/sync"/* "$RZ/var/log"/* "$RZ/root/.bash_history"
ok "greetd entra solo como «naranjos»; llavero de pacman nuevo en cada arranque"

# --- 5. cachés y el arranque de la ISO ---------------------------------------------------------------
say "Preparando cachés, initramfs y kernel firmado…"
K=$(ls "$RZ/usr/lib/modules" | head -n1)
sudo chroot "$RZ" /bin/bash -c "ldconfig; depmod -a '$K'; update-mime-database /usr/share/mime >/dev/null 2>&1; \
  glib-compile-schemas /usr/share/glib-2.0/schemas 2>/dev/null; gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor 2>/dev/null; \
  fc-cache -s >/dev/null 2>&1; systemd-tmpfiles --create >/dev/null 2>&1; true"
sudo chroot "$RZ" /usr/bin/naranjos-kernel instala >/dev/null 2>&1 || true
[ -e "$RZ/boot/vmlinuz-linux-naranjos" ] || sudo cp "$RZ/usr/lib/modules/$K/vmlinuz" "$RZ/boot/vmlinuz-linux-naranjos"
printf 'MODULOS="isofs squashfs overlay loop sr_mod cdrom usb_storage uas"\nMICROCODIGO=todos\n' | sudo tee "$RZ/etc/naranjos/initramfs.conf" >/dev/null
sudo chroot "$RZ" /usr/bin/naranjos-initramfs --todos > "$T/initramfs.log" 2>&1 || { tail -20 "$T/initramfs.log"; die "No pude hacer el initramfs"; }
sudo mkdir -p "$ISO/boot/grub" "$ISO/naranjos/x86_64"
sudo sbsign --key "$MOK/MOK.priv" --cert "$MOK/MOK.pem" --output "$ISO/boot/vmlinuz-linux-naranjos" "$RZ/boot/vmlinuz-linux-naranjos" >/dev/null 2>&1 \
  || die "No pude firmar el kernel"
sudo sbverify --cert "$MOK/MOK.pem" "$ISO/boot/vmlinuz-linux-naranjos" >/dev/null 2>&1 || die "La firma del kernel no se verifica"
sudo cp "$RZ/boot/initramfs-linux-naranjos.img" "$ISO/boot/"
ok "kernel $K firmado con la MOK e initramfs con el modo en vivo"

# --- 6. la raíz comprimida ---------------------------------------------------------------------------
desmonta; trap - EXIT
say "Comprimiendo la raíz (squashfs + xz; unos minutos)…"
sudo mksquashfs "$RZ" "$ISO/naranjos/x86_64/raiz.sfs" -comp xz -Xbcj x86 -b 1M -noappend -no-progress -quiet \
  -e boot/initramfs-linux-naranjos.img > /dev/null
ok "raiz.sfs: $(du -h "$ISO/naranjos/x86_64/raiz.sfs" | cut -f1)"

# --- 7. GRUB firmado y la partición EFI de la ISO ----------------------------------------------------
say "GRUB firmado y partición EFI…"
G=$T/grub; mkdir -p "$G/md/fonts"
printf 'search --no-floppy --label %s --set=root\nset prefix=($root)/boot/grub\nconfigfile $prefix/grub.cfg\necho "NaranjOS: no encuentro el medio %s"\nsleep 15\n' "$ETIQUETA" "$ETIQUETA" > "$G/inicio.cfg"
cp "$ARR"/fuentes/*.pf2 "$G/md/fonts/" 2>/dev/null || true
tar -C "$G/md" -cf "$G/memdisk.tar" fonts
MODS="part_gpt part_msdos fat iso9660 normal boot linux chain configfile search search_label search_fs_uuid search_fs_file
echo test true sleep reboot halt efi_gop efi_uga all_video video_fb gzio minicmd ls cat help efifwsetup regexp gfxterm font memdisk tar"
# shellcheck disable=SC2086
grub-mkimage -O x86_64-efi -d "$GRUBDIR" -p /boot/grub -c "$G/inicio.cfg" --sbat "$ARR/sbat.csv" -m "$G/memdisk.tar" \
  -o "$G/grubx64.sinfirmar" $MODS || die "grub-mkimage falló"
sudo sbsign --key "$MOK/MOK.priv" --cert "$MOK/MOK.pem" --output "$G/grubx64.efi" "$G/grubx64.sinfirmar" >/dev/null 2>&1 || die "No pude firmar GRUB"
sed -e "s/@ETIQUETA@/$ETIQUETA/g" -e "s/@VERSION@/$VERSION/g" "$DATOS/grub.cfg" | sudo tee "$ISO/boot/grub/grub.cfg" >/dev/null
# la partición EFI (FAT) que lleva dentro la ISO: shim → GRUB firmado; MokManager y la clave pública de NaranjOS
EFI=$T/efiboot.img; truncate -s 16M "$EFI"; mkfs.fat -n NARANJOSEFI "$EFI" >/dev/null
mkdir -p "$T/efi"; sudo mount -o loop "$EFI" "$T/efi"
sudo mkdir -p "$T/efi/EFI/BOOT"
sudo cp "$SHIM/shimx64.efi" "$T/efi/EFI/BOOT/BOOTX64.EFI"
sudo cp "$SHIM/mmx64.efi" "$T/efi/EFI/BOOT/mmx64.efi"
sudo cp "$G/grubx64.efi" "$T/efi/EFI/BOOT/grubx64.efi"
sudo cp "$MOK/MOK.der" "$T/efi/NARANJOS-MOK.der"           # la clave PÚBLICA: para registrarla en MokManager
sudo umount "$T/efi"
sudo cp "$MOK/MOK.der" "$ISO/NARANJOS-MOK.der"
sudo install -Dm644 "$DATOS/LEEME.txt" "$ISO/LEEME.txt"
ok "shim (Canonical/Microsoft) → GRUB firmado con la MOK de NaranjOS"

# --- 8. la ISO híbrida (DVD y USB) -------------------------------------------------------------------
say "Escribiendo la ISO…"
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
echo "${D}  (la raíz de trabajo queda en $T; bórrala con: sudo rm -rf $T)${Z}"
