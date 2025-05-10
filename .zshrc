### Oh-My-Zsh ###############################################################
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="amuse"

# your requested plugins
plugins=(
  common-aliases
  uv
  git
  pip
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
source $HOME/.aliases

# completions
autoload -Uz compinit && compinit
