# NaranjOS · autocompletado de «naranjos» para bash
_naranjos(){
  local cur=${COMP_WORDS[COMP_CWORD]}
  if [ "$COMP_CWORD" -eq 1 ]; then
    mapfile -t COMPREPLY < <(compgen -W "$(naranjos --lista 2>/dev/null)" -- "$cur")
  else
    mapfile -t COMPREPLY < <(compgen -f -- "$cur")
  fi
}
complete -F _naranjos naranjos
