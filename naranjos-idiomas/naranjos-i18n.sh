# NaranjOS · traducciones para los scripts de NaranjOS (se carga con «. naranjos-i18n.sh»)
# Dominio gettext «naranjos»: /usr/share/locale/<idioma>/LC_MESSAGES/naranjos.mo
export TEXTDOMAIN=naranjos TEXTDOMAINDIR=/usr/share/locale
_(){ gettext "$1"; }
# idioma corto del usuario (es, en, gl…)
naranjos_lengua(){ local l="${LANGUAGE:-${LC_ALL:-${LC_MESSAGES:-${LANG:-es}}}}"; l="${l%%[_.:@]*}"; [ "$l" = C ] && l=en; echo "${l:-es}"; }
# fichero de NaranjOS en el idioma del usuario: naranjos_traducido <dir> <fichero> (si no hay, el español)
naranjos_traducido(){ local l; l=$(naranjos_lengua); if [ -r "$1/$l/$2" ]; then echo "$1/$l/$2"; else echo "$1/$2"; fi; }
