# NaranjOS · herramientas de terminal (paquete naranjos-zsh; lo carga /etc/zsh/zshrc)
#   cd <trozo>   zoxide: salta a carpetas que ya visitaste (cd naran → ~/naranjos-recetas)
#   Ctrl+R       fzf: busca en el historial · Ctrl+T: busca ficheros · Alt+C: entra en una carpeta
#   ls / ll / la / lt   eza (con iconos y git) · ver <fichero>: bat (con colores) · rg / fd: buscar texto / ficheros
if command -v zoxide >/dev/null; then eval "$(zoxide init zsh --cmd cd)"; fi
if command -v fzf >/dev/null; then
  source <(fzf --zsh 2>/dev/null)
  command -v fd >/dev/null && export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git' FZF_CTRL_T_COMMAND='fd --hidden --exclude .git'
  _naranjos_fzf_colores(){   # los del tema cítrico
    local a=ff8700 t=e6e6e6 s=1e1e1e
    if [ -r "$HOME/.config/naranjos/tema/colores" ]; then
      a=$(sed -n 's/^COLOR_ACENTO=//p' "$HOME/.config/naranjos/tema/colores"); t=$(sed -n 's/^COLOR_TEXTO=//p' "$HOME/.config/naranjos/tema/colores")
      s=$(sed -n 's/^COLOR_SUP=//p' "$HOME/.config/naranjos/tema/colores")
    fi
    export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=rounded --prompt='❯ ' --pointer='▶' --marker='✓' --color=fg:#$t,hl:#$a,fg+:#$t,bg+:#$s,hl+:#$a,prompt:#$a,pointer:#$a,marker:#$a,border:#$a,info:#$a"
  }
  _naranjos_fzf_colores
fi
if command -v eza >/dev/null; then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='eza -l --group-directories-first --icons=auto --git --time-style=relative'
  alias la='eza -la --group-directories-first --icons=auto --git'
  alias lt='eza --tree --level=2 --icons=auto --git-ignore'
fi
if command -v bat >/dev/null; then
  export BAT_THEME=ansi          # los colores de la terminal, que son los del tema
  alias ver='bat --style=numbers,changes'
  command -v fzf >/dev/null && alias ff="fzf --preview 'bat --color=always --style=numbers {}'"
fi
# funciones de NaranjOS (naranjos-utiles)
for _f in comprime descomprime convierte video-ligero usb-iso formatea-usb discos; do alias $_f="naranjos-utiles $_f"; done; unset _f
alias contenedores='lazydocker'
