export devdir="$HOME/Dev"

source "$HOME"/.functions.sh

[[ -f "$HOME/.secret.sh" ]] && source "$HOME/.secret.sh"

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

alias dotf='cd "$HOME"/.dotfiles/'

alias dotfn='dotf && cd .config/nvim'

alias gal='alias | grep'

alias fp='ps -eaf | grep'

alias vag='nvim "$HOME"/.globalrc.sh && src && echo "Updated Global Aliases" '

alias vfg='nvim "$HOME"/.functions.sh && src && echo "Updated Global Functions" '
