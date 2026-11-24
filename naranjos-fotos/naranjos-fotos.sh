# NaranjOS · aviso al entrar si se ha arrancado una foto del sistema (naranjos-fotos)
if [ -r /run/naranjos-foto ] && [ -t 1 ]; then
  _n=$(sed -n 's/^n=//p' /run/naranjos-foto)
  printf '\033[1;38;5;208mNaranjOS:\033[0m estás en la foto %s (lo que cambies se pierde al apagar).\n' "$_n"
  printf '  Para quedarte con ella: sudo fotos vuelve %s\n' "$_n"
  unset _n
fi
