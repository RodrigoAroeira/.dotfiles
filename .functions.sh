function mkdev() {
  name=$1
  path=~/Dev/$name
  mkdir $path && cd $path
}

export mkdev

function devdir() {
  folder=$1
  path=~/Dev/$folder
  cd $path
}

_devdir() {
  local cur prev words cword
  _init_completion || return
  local completions=($(cd ~/Dev/ && compgen -o dirnames -- "$cur"))
  if [[ ${#completions[@]} -gt 0 ]]; then
    COMPREPLY=("${completions[@]}/")
  fi
}

complete -o nospace -F _devdir devdir

export devdir

function findProcess() {
  ps -eaf | grep $1
}

function virtualenv() {
  # If no argument is provided
  createdNow=false
  if [ -z "$1" ]; then
    # Check if either "venv" or ".venv" exists and store in a variable
    if [ -d "venv" ]; then
      env_folder="venv"
    elif [ -d ".venv" ]; then
      env_folder=".venv"
    else
      echo "Usage: virtualenv <env_name>"
      return 1
    fi
  else
    # If an argument is provided, use it as the environment name
    env_folder="$1"

    # If the directory doesn't exist, create the environment
    if [ ! -d "$env_folder" ]; then
      python -m venv "$env_folder"
      createdNow=true
    fi
  fi

  # Activate the virtual environment
  source "$env_folder/bin/activate"

  # Check for requirements.txt
  if [ "$createdNow" = true ] && [ -e "requirements.txt" ]; then
    echo "Automatically installing requirements.txt, please wait"
    pip install -r requirements.txt --require-virtualenv # &
  fi

}
