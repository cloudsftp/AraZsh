#!/bin/bash

ZSHRC="${HOME}/.zshrc"

SCRIPT_DIR="Scripts"
MAIN_SCRIPT="${SCRIPT_DIR}/main.zsh"
COMMAND_SCRIPT="${SCRIPT_DIR}/commands.zsh"
DIR_SCRIPT="${SCRIPT_DIR}/dir-commands.zsh"

DIR_CFG="dir.cfg"
DIR_COMMANDS_GEN="${SCRIPT_DIR}/dir-commands-generator.py"
CONDA_INSTALL_DIR="${HOME}/anaconda3"

sudo apt install -y zsh

# Install oh my zsh

OH_MY_ZSH_INSTALL_SCRIPT="install-oh-my-zsh.sh"
wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O "${OH_MY_ZSH_INSTALL_SCRIPT}"
sudo chmod +x ${OH_MY_ZSH_INSTALL_SCRIPT}
./${OH_MY_ZSH_INSTALL_SCRIPT} --unattended

# Copy dotfile

cp ".zshrc" "${HOME}/.zshrc"

# Generate main.zsh

echo "source $(pwd)/${COMMAND_SCRIPT}" > "${MAIN_SCRIPT}"

# Create dir-commands.zsh

if [[ -f "${DIR_CFG}" ]]; then
  python "${DIR_COMMANDS_GEN}" "${DIR_CFG}" "${DIR_SCRIPT}"
  echo "source $(pwd)/${DIR_SCRIPT}" >> "${MAIN_SCRIPT}"
else
  echo "${DIR_CFG} missing. Skipping Generation of ${DIR_SCRIPT}"
fi

# Include main.zsh

RC_STAMP="AraZsh"
if [[ -z "$(grep ${RC_STAMP} ${ZSHRC})" ]]; then
  echo "# ${RC_STAMP}" >> "${ZSHRC}"
  echo "source $(pwd)/${MAIN_SCRIPT}" >> "${ZSHRC}"
fi

# Init conda

if [[ -d "${CONDA_INSTALL_DIR}" ]]; then
  "${CONDA_INSTALL_DIR}/bin/conda" init zsh
fi
