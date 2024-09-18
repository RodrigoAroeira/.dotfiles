function mkdev() {
  name=$1
  path=~/Dev/$name
  mkdir "$path" && cd "$path" || return
}

export mkdev

function devdir() {
  folder=$1
  path=~/Dev/$folder
  cd "$path" || return
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

export devdir="$HOME/Dev/"

function findProcess() {
  ps -eaf | grep "$1"
}

function virtualenv() {
  # If no argument is provided
  createdNow=false
  local env_folder

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

#helper function
function _create_directory_if_needed() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
  fi
}

function _setup_daily_readme() {
  local file_path="$1"
  if [ ! -f "$file_path" ]; then
    echo -e "TODAY'S TASK: \n" >"$file_path"
    echo -e "STARTING: \n" >>"$file_path"
    echo -e "ENDED: \n" >>"$file_path"
  fi
}

daily_folder="$devdir"/"CurrentDaily"
daily_repo="$devdir"/DailyChallenges

function start-daily() {
  if [ "$DAILY_CHALLENGE_STARTED" = true ]; then
    echo "Daily Challenge already started."
    cd "$daily_folder"
    return
  fi
  file=README.md
  _create_directory_if_needed "$daily_folder"
  cd "$daily_folder" || (return && echo "Something went wrong")

  _setup_daily_readme "$file"

  export DAILY_CHALLENGE_STARTED=true
}

function cancel-daily() {
  if [ -z "$DAILY_CHALLENGE_STARTED" ]; then
    echo "Daily challenge not yet started."
    return 1
  fi

  rm -rf "$daily_folder"
  echo "Daily challenge canceled"
  unset DAILY_CHALLENGE_STARTED
  cd "$HOME" || (return && echo "Something went wrong")
}

function end-daily() {

  if [ -z "$DAILY_CHALLENGE_STARTED" ]; then
    echo "Daily challenge not yet started."
    return 1
  fi

  if [ $# -eq 0 ]; then
    echo "Usage: end-daily <devdir>"
    return 1
  fi

  local folder_in_repo="$daily_repo/$1"

  _create_directory_if_needed "$folder_in_repo"

  if [ -n "$(find "$folder_in_repo" -mindepth 1 -print -quit)" ]; then
    echo "Folder exists and is not empty"
    return 1
  fi

  mv "$daily_folder"/* "$folder_in_repo"
  rm -r "$daily_folder"

  unset DAILY_CHALLENGE_STARTED
}
