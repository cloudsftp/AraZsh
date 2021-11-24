# editor

export EDITOR="vim"

# directories

function dir_general() {
  dir="$1"
  proj_name="$2"

  cd "$dir"

  if [ -n "$proj_name" ]
  then
    cd "$proj_name"
  fi

  if [ -d .git ]
  then
    git fetch
  fi

  ll
}
