# editor

export EDITOR="vim"

# directories

function dir_general() {
  dir="$1"
  proj_name="$2"

  cd "$dir"

  if [ -n "$proj_name" ]
  then
    if [ ! -d "$proj_name" ]; then
      echo $proj_name does not exist yet
      gclone "$proj_name"
      echo
    fi

    cd "$proj_name"
  fi

  if [ -d .git ]
  then
    git fetch
  fi

  ls
}

# directory completion

function _dir_general_complete() {
  local cur dir

  dir="$1"
  cur="${COMP_WORDS[COMP_CWORD]}"
}
