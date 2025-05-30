#!/usr/bin/env bash
set -euo pipefail

echo "▶ Bootstrapping Eze Codespace dotfiles…"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

install_oh_my_zsh() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "▶ Installing Oh My Zsh…"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  else
    echo "▶ Updating Oh My Zsh…"
    git -C "$HOME/.oh-my-zsh" pull --quiet
  fi
}

link_dotfiles() {
  echo "▶ Symlinking core dotfiles…"
  ln -sf "$DOTFILES_DIR/.zshrc"       "$HOME/.zshrc"
  ln -sf "$DOTFILES_DIR/.zsh_aliases" "$HOME/.zsh_aliases"
  #ln -sf "$DOTFILES_DIR/.gitconfig"   "$HOME/.gitconfig"
  ln -sf "$DOTFILES_DIR/.bashrc"        "$HOME/.bashrc"
}

install_plugins() {
  echo "▶ Installing Zsh plugins…"
  for repo in \
    "https://github.com/zsh-users/zsh-autosuggestions.git" \
    "https://github.com/zsh-users/zsh-syntax-highlighting.git"
  do
    # Strip off the “.git” to get the real plugin folder name
    name="$(basename "$repo" .git)"
    dest="$ZSH_CUSTOM/plugins/$name"

    if [[ ! -d "$dest" ]]; then
      git clone --depth=1 "$repo" "$dest"
    fi
  done
}

install_python_tools() {
  echo "▶ Installing Python CLI tools via pipx…"
  if ! command -v python3 &>/dev/null; then
    echo "❌ python3 not found; please install it first." >&2
    exit 1
  fi

  if ! command -v pipx &>/dev/null; then
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
    # reload profile so pipx is on PATH (may vary by shell)
    source "$HOME/.profile" || true
  fi

  for pkg in ruff uv; do
    if ! command -v "$pkg" &>/dev/null; then
      pipx install "$pkg"
    fi
  done
}

install_python_requirements() {
  if [[ -f "$DOTFILES_DIR/requirements.txt" ]]; then
    echo "▶ Installing Python packages from requirements.txt…"
    if ! command -v python3 &>/dev/null; then
      echo "❌ python3 not found; please install it first." >&2
      exit 1
    fi
    python3 -m pip install --user -r "$DOTFILES_DIR/requirements.txt"
  else
    echo "ℹ️  No requirements.txt found, skipping Python package installation."
  fi
}

main() {
  install_oh_my_zsh
  link_dotfiles
  install_plugins
  install_python_tools
  install_python_requirements
  echo "✅ dotfiles install done"
}

main
