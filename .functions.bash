_devdir() {
  local cur
  _init_completion || return
  local completions
  mapfile -t completions < <(cd ~/Dev/ && compgen -o dirnames -- "$cur")
  if [[ ${#completions[@]} -gt 0 ]]; then
    COMPREPLY=("${completions[@]}/")
  fi
}

complete -o nospace -F _devdir devdir
complete -o nospace -F _devdir mkdev
