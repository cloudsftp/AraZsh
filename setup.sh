#!/usr/bin/env sh

set -e

installer_dir="$(pwd)"

ara_dir="${HOME}/.ara-zsh"
omz_dir="${HOME}/.oh-my-zsh"

target_dir="target"

plugins_dir="$target_dir/plugins"
themes_dir="$target_dir/themes"
completions_dir="$target_dir/completions"

stow -t "${HOME}" "$bootstrap_dir"

# Install oh my zsh

if [ -d "$omz_dir" ]; then
    echo Oh My ZSH already installed. Skipping installation...
    echo

else
    echo Installing Oh My ZSH...
    echo

    omz_install_script="/tmp/install-omz.sh"
    wget \
        https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
        -O "$omz_install_script"
    sh "$omz_install_script" --keep-zshrc --unattended
fi

# Install plugins

plugin_urls="\
    git@github.com:zsh-users/zsh-syntax-highlighting \
    git@github.com:zsh-users/zsh-autosuggestions \
"

mkdir -p "$plugins_dir"
cd "$plugins_dir"
for plugin_url in $plugin_urls; do
    plugin_name="${plugin_url##*/}"

    if [ -d "$plugin_name" ]; then
        echo Plugin "$plugin_name" already exists. Updating...
        echo

        cd "$plugin_name"
        git pull
        cd -
    else
        echo Plugin "$plugin_name" does not exist. Cloning...
        echo

        git clone "$plugin_url"
    fi
done
cd "$installer_dir"

# Generate directory commands

mkdir -p "$completions_dir"
dir_cfg="dir.cfg"
if [ ! -f "$dir_cfg" ]; then
    echo Configuration "$dir_cfg" does not exists. Skipping command generation...
    echo
else
    echo Generating commands
    echo

    python3 dir-commands-generator.py "$dir_cfg" "$completions_dir"
fi

# Bootstrap .zshrc

zshrc="${HOME}/.zshrc"
if [ -f "$zshrc" ]; then
    echo "$zshrc" already exists. Skipping bootstrapping...
    echo
    echo Please manually check the "$zshrc" file for completeness
    echo

else
    echo "$zshrc" does not exist. Creating...
    echo

    cp zshrc-bootstrap.zsh "$zshrc"
fi

# Link ~/.ara-zsh

mkdir -p "$ara_dir"
stow -d "$target_dir" -t "$ara_dir" .
