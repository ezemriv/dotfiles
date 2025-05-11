# ~/.bashrc  — from dotfiles

# If this is an interactive Bash session and Zsh is available, switch to it:
if [[ $- == *i* ]] && [[ -z $ZSH_VERSION ]] && command -v zsh >/dev/null; then
  exec zsh -l
fi
