_devdir() {
  local cur=${words[-1]}
  local base_dir=~/Dev
  local search_dir="$base_dir/${cur%/*}"  # Determine the directory to search

  # Adjust search_dir for top-level input without a slash
  if [[ ! $cur == */* ]]; then
    search_dir="$base_dir"
  fi

  # Find directories and strip the base path
  local folders=()
  if [[ -d $search_dir ]]; then
    folders=($(find "$search_dir" -maxdepth 1 -type d | sed "s|^$base_dir/||"))
  fi

  compadd -Q -S '/' -- "${folders[@]}"
}

compdef _devdir devdir
compdef _devdir mkdev
