#### CUSTOM ALIASES

alias lls='ls -larth'

alias videomode='source ~/.videobashrc'

alias cd..="echo 'Previous dir:' && pwd && cd .."

alias va='nvim ~/.bashrc && source ~/.bashrc && echo "Updated .bashrc" '

alias vf='nvim ~/.functions.sh && source ~/.functions.sh && echo "Updated Functions" '

alias tree='tree -L 2'

alias clr="PS1='$ '"

alias src='source ~/.bashrc'

alias pipe="echo -n '|' | xclip -sel clip"

alias tuiuiu='ssh rodrigo-aroeira@tuiuiu.fisica.ufmg.br'

alias kagome='ssh rodrigo@150.164.14.134'

alias lcc01='ssh rodrigo-aroeira@ia01.LCC.ufmg.br'

alias lcc02='ssh rodrigo-aroeira@ia02.LCC.ufmg.br'

alias dotf='cd ~/.dotfiles/'

source ~/.functions.sh

alias gal='alias | grep'

alias fp='ps -eaf | grep'

bind '"\C-l":"clear\n"'
