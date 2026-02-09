#!/bin/bash

ZSHRC="${HOME}/.zshrc"

SCRIPT_DIR="Scripts"
MAIN_SCRIPT="${SCRIPT_DIR}/main.zsh"
COMMAND_SCRIPT="${SCRIPT_DIR}/commands.zsh"
DIR_SCRIPT="${SCRIPT_DIR}/dir-commands.zsh"

DIR_CFG="dir.cfg"
DIR_COMMANDS_GEN="${SCRIPT_DIR}/dir-commands-generator.py"

COMPLETE_DIR="Complete"
OH_MY_ZSH_COMPLETE_DIR="${HOME}/.oh-my-zsh/completions"

# Install oh my zsh

OH_MY_ZSH_INSTALL_SCRIPT="install-oh-my-zsh.sh"
wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O "${OH_MY_ZSH_INSTALL_SCRIPT}"
chmod +x ${OH_MY_ZSH_INSTALL_SCRIPT}
./${OH_MY_ZSH_INSTALL_SCRIPT} --unattended

# Install plugins

git submodule init && git submodule update
for plugin in $(ls Plugins); do
  cp -r "Plugins/${plugin}" "${HOME}/.oh-my-zsh/custom/plugins/${plugin}"
done

# Copy dotfile

cp ".zshrc" "${HOME}/.zshrc"

# Generate main.zsh

echo "source $(pwd)/${COMMAND_SCRIPT}" > "${MAIN_SCRIPT}"

# Create dir-commands.zsh

if [[ -f "${DIR_CFG}" ]]; then
  mkdir -p "${COMPLETE_DIR}" "${OH_MY_ZSH_COMPLETE_DIR}"
  python3 "${DIR_COMMANDS_GEN}" "${DIR_CFG}" "${DIR_SCRIPT}" "${COMPLETE_DIR}"
  echo "source $(pwd)/${DIR_SCRIPT}" >> "${MAIN_SCRIPT}"
  cp "${COMPLETE_DIR}"/* "${OH_MY_ZSH_COMPLETE_DIR}"
  rm -f "${HOME}"/.zcompdump*
else
  echo "${DIR_CFG} missing. Skipping Generation of ${DIR_SCRIPT}"
fi

# Include main.zsh

RC_STAMP="AraZsh"
if [[ -z "$(grep ${RC_STAMP} ${ZSHRC})" ]]; then
  echo "# ${RC_STAMP}" >> "${ZSHRC}"
  echo "source $(pwd)/${MAIN_SCRIPT}" >> "${ZSHRC}"
fi
