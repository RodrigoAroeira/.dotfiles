export devdir="$HOME/Dev"

source "$HOME"/.functions.sh

if [ -n "$ZSH_VERSION" ]; then
  source "$HOME"/.functions.zsh
elif [ -n "$BASH_VERSION" ]; then
  source "$HOME"/.functions.bash
fi

alias .=source

alias lls='ls -larth'

alias la='ls -a'

alias cd..="echo 'Previous dir:' && pwd && cd .."

alias tree='tree -L 2'

alias clr="PS1='$ '"

alias pipe="echo -n '|' | xclip -sel clip"

alias tuiuiu='ssh rodrigo-aroeira@tuiuiu.fisica.ufmg.br'

alias kagome='ssh rodrigo@150.164.14.134'
export kagome="150.164.14.134"

alias ia01='ssh rodrigo-aroeira@ia01.LCC.ufmg.br'
export ia01="ia01.LCC.ufmg.br"

alias ia02='ssh rodrigo-aroeira@ia02.LCC.ufmg.br'
export ia02="ia02.LCC.ufmg.br"

alias dotf='cd "$HOME"/.dotfiles/'

alias dotfn='dotf && cd .config/nvim'

alias gal='alias | grep'

alias fp='ps -eaf | grep'

alias ssh="kitten ssh"

alias vim="nvim --clean"

alias vag='nvim "$HOME"/.globalrc.sh && src && echo "Updated Global Aliases" '

alias vfg='nvim "$HOME"/.functions.sh && src && echo "Updated Global Functions" '
