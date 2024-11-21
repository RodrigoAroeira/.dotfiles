function mkdev() {
  name=$1
  path=~/Dev/$name
  mkdir "$path" && cd "$path" || return
}

function devdir() {
  local folder=$1
  local path=~/Dev/"$folder"
  cd "$path" || return
}

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

export devdir="$HOME/Dev/"

function virtualenv() {
  local env_folder="$1"
  local createdNow=false

  # If no argument is provided, check for existing environments
  if [ -z "$env_folder" ]; then
    if [ -d ".venv" ]; then
      env_folder=".venv"
    elif [ -d "venv" ]; then
      env_folder="venv"
    else
      echo "Usage: ${FUNCNAME[0]} <env_name>"
      return 1
    fi
  fi

  # Create the virtual environment if it doesn't exist
  if [ ! -d "$env_folder" ]; then
    python3 -m venv "$env_folder"
    createdNow=true
  fi

  # Activate the virtual environment
  source "$env_folder/bin/activate"

  # Automatically install requirements if the environment was just created
  if $createdNow && [ -f "requirements.txt" ]; then
    echo "Automatically installing requirements.txt, please wait..."
    pip install -r requirements.txt --require-virtualenv
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
  local challenge="$2"
  if [ ! -f "$file_path" ]; then
    echo -e "# TODAY'S TASK: $2\n" >"$file_path"
    echo -e "STARTING:\n" >>"$file_path"
    echo -e "ENDED:\n" >>"$file_path"
  fi
}

daily_folder="$devdir"/"CurrentDaily"
daily_repo="$devdir"/DailyChallenges

function start-daily() {
  if [ -d "$daily_folder" ]; then
    echo "Daily Challenge already started."
    cd "$daily_folder" || return
    return
  fi
  local file=README.md
  local challenge="$1"
  _create_directory_if_needed "$daily_folder"
  cd "$daily_folder" || (return && echo "Something went wrong")

  _setup_daily_readme "$file" "$challenge"

}

function cancel-daily() {
  if [ ! -d "$daily_folder" ]; then
    echo "Daily challenge not yet started."
    return 1
  fi
  rm -rf "$daily_folder"
  echo "Daily challenge canceled"
  cd "$HOME" || (return && echo "Something went wrong")
}

function end-daily() {

  if [ ! -d "$daily_folder" ]; then
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

  cd "$folder_in_repo"/.. || return
  gh repo create
  cd "$folder_in_repo" || return

  mv "$daily_folder"/* "$folder_in_repo"
  rm -r "$daily_folder"

  unset DAILY_CHALLENGE_STARTED
}

function setupBasicClangd() {
  local filename=".clangd"
  cat <<EOF >"$filename"
CompileFlags:
  Add:
    - -I$(pwd)/headers
    - -I$(pwd)/includes/usr/include
EOF
}

function setupBasicMakefile() {
  local filename="Makefile.test"
  local projectName=$1
  function tab() {
    printf '\t'
  }
  cat <<EOF >"$filename"
CXX = g++

STD = c++11

SRC_DIR = src
SRC_FILES = \$(wildcard \$(SRC_DIR)/*.cpp)

HEADER_DIR = headers
INCLUDE_DIR = includes/usr/include

OUT = $projectName

CXXFLAGS = -I\$(HEADER_DIR) -O3 -std=\$(STD)

build:
$(tab)\$(CXX) \$(SRC_FILES) \$(CXXFLAGS) -o \$(OUT)

run:
$(tab)./\$(OUT)

clean:
$(tab)rm -f \$(OUT)

.PHONY: build run clean
EOF
}

function setupBasicCMake() {
  local filename="CMakeLists.txt"
  local projectName=${1:-"PLACEHOLDER"}

  cat <<EOF >"$filename"
cmake_minimum_required(VERSION 3.10)

set(PROJECT_NAME "$projectName")

project("\${PROJECT_NAME}" VERSION 1.0)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(SRC_DIR "src")
file(GLOB SRC_FILES "\${SRC_DIR}/*.cpp")

add_executable(\${PROJECT_NAME} \${SRC_FILES})

target_include_directories(\${PROJECT_NAME} PRIVATE headers includes/usr/include)

add_custom_target(run
COMMAND \${PROJECT_NAME}
DEPENDS \${PROJECT_NAME}
WORKING_DIRECTORY \${CMAKE_PROJECT_DIR}
)
EOF
}

function setupProject() {
  mkdir headers && echo "Created \`./headers/\` directory"
  mkdir src && echo "Created \`./src/\` directory"
}
