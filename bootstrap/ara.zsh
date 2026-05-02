export ZSH="${HOME}/.oh-my-zsh"
ZSH_CUSTOM="${HOME}/.ara-zsh"

zstyle ':omz:update' mode auto

HIST_STAMPS="yyyy-mm-dd"
ZSH_THEME="juanghurtado"

plugins=(git jj kubectl zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
