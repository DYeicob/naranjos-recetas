# NaranjOS · PATH del sistema (lo cargan todas las shells de inicio de sesión)
if [ "$(id -u)" -eq 0 ]; then
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
else
  PATH=/usr/local/bin:/usr/bin
fi
export PATH
