function mkdev() {
  local name=$1
  local target=~/Dev/"$name"
  mkdir "$target" && cd "$target" || return
}

function devdir() {
  local folder=$1
  local target=~/Dev/"$folder"
  cd "$target" || return
}

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
      echo "Usage: $0 <env_name>" 1>&2
      return 1
    fi
  fi

  # Create the virtual environment if it doesn't exist
  if [ ! -d "$env_folder" ]; then
    if command -v uv &>/dev/null; then
      uv venv "$env_folder" --seed || {
        echo "Failed to create venv using uv"
        return 1
      }
    else
      python3 -m venv "$env_folder" || {
        echo "Failed to create venv using python3 -m venv"
        return 1
      }
    fi
    createdNow=true
  fi

  # Activate the virtual environment
  source "$env_folder/bin/activate"

  # Automatically install requirements if the environment was just created
  if $createdNow && [ -f "requirements.txt" ]; then
    echo "Automatically installing requirements.txt, please wait..."
    uv pip install -r requirements.txt || pip install -r requirements.txt --require-virtualenv
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
    echo "Folder '$folder_in_repo' exists and is not empty"
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

QUEUE_PATH="/tmp/queue.sh"

function queue() {
  local usage="$(
    cat <<'EOF'
Usage: queue [args...]
       queue --help
       queue --list
       queue --clear
       queue --path
       queue --run
EOF
  )"

  case "$1" in
  "")
    echo "$usage"
    return 1
    ;;
  --help)
    echo "$usage"
    return
    ;;
  --list)
    echo "Queued commands:"
    if [[ ! -f $QUEUE_PATH ]]; then
      echo "(empty)"
    else
      local show_cmd
      if command -v bat &>/dev/null; then
        show_cmd="bat -p"
      else
        show_cmd="tail -n +2"
      fi
      eval "$show_cmd" "$QUEUE_PATH"
    fi
    return
    ;;
  --clear)
    rm -f "$QUEUE_PATH" && echo "Queue cleared."
    return
    ;;
  --path)
    echo "$QUEUE_PATH"
    return
    ;;
  --run)
    run-queue
    return
    ;;
  esac
  if [[ ! -f "$QUEUE_PATH" ]]; then
    echo "#!/usr/bin/env bash" >"$QUEUE_PATH"
    chmod +x "$QUEUE_PATH"
  fi

  local bad_args=()
  local buf=""
  for arg in "$@"; do
    if [[ "$arg" == *"--"* && "$arg" == *" "* ]]; then
      bad_args+=("$arg")
    fi

    if [[ "$arg" == "--" ]]; then
      [[ -n "$buf" ]] && printf '%s\n' "$buf" >>"$QUEUE_PATH"
      buf=""
    else
      buf+="$arg "
    fi
  done

  [[ -n "$buf" ]] && printf '%s\n' "$buf" >>"$QUEUE_PATH"

  if ((${#bad_args[@]} > 0)); then
    echo "warning: possible quoted command groups detected; '--' may not be parsed correctly" >&2
    printf '  problematic args: %s\n' "${bad_args[@]}" >&2
  fi
}

function run-queue() {
  if [[ ! -f "$QUEUE_PATH" ]]; then
    echo "No commands in queue."
    return 1
  fi

  echo "Running queued commands from $QUEUE_PATH..."
  local isolate=false
  local should_delete=false
  for arg in "$@"; do
    case "$arg" in
    -d | --delete)
      should_delete=true
      ;;
    -i | --isolate)
      isolate=true
      ;;
    esac
  done

  local has_err=false
  if $isolate; then
    bash "$QUEUE_PATH" || has_err=true
  else
    source "$QUEUE_PATH" || has_err=true
  fi

  if $should_delete; then
    rm -f "$QUEUE_PATH"
    echo "Queue cleared."
  fi

  if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    return $has_err # If sourced, return the error code
  else
    exit $has_err # If executed, exit with the error code
  fi
}
