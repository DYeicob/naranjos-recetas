# NaranjOS · PATH del sistema (lo cargan todas las shells de inicio de sesión)
# /usr/sbin también para tu usuario (al final): lsmod, modprobe, ldconfig… sin escribir la ruta
if [ "$(id -u)" -eq 0 ]; then
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
else
  PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
fi
export PATH
