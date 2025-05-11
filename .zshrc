### [dotfiles] ensure ~/.local/bin is in PATH
export PATH="$HOME/.local/bin:$PATH"

### [dotfiles] load aliases (if available)
[[ -f "$HOME/.zsh_aliases" ]] && source "$HOME/.zsh_aliases"

### [dotfiles] Oh My Zsh setup
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="amuse"
plugins=(
  #common-aliases
  uv
  git
  pip
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Only source OMZ if it's installed
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# Completion
autoload -Uz compinit && compinit
