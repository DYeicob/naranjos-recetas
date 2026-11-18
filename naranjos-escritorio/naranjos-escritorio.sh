# NaranjOS · /etc/profile.d/naranjos-escritorio.sh
# Al iniciar sesión, completa la configuración del escritorio que le falte al usuario.
if [ "$(id -u)" -ge 1000 ] && command -v naranjos-config-usuario >/dev/null 2>&1; then
  naranjos-config-usuario >/dev/null 2>&1
fi
