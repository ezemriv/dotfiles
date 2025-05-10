#!/usr/bin/env bash
set -euo pipefail

echo "▶ Bootstrapping Eze Codespace dotfiles…"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# 1. Pull latest OMZ (in case uv plugin was added recently)
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  git -C "$HOME/.oh-my-zsh" pull --quiet
fi

# 2. Symlink core dotfiles
ln -sf "$DOTFILES_DIR/.zshrc"     "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.aliases"   "$HOME/.aliases"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# 3. Install zsh plugins if missing
for repo in \
  "https://github.com/zsh-users/zsh-autosuggestions.git" \
  "https://github.com/zsh-users/zsh-syntax-highlighting.git"
do
  name="${repo##*/}"
  [[ -d "$ZSH_CUSTOM/plugins/$name" ]] || \
    git clone --depth=1 "$repo" "$ZSH_CUSTOM/plugins/$name"
done

# 4. Install Python tools
python3 -m pip install --user --quiet uv ruff

# 5. Install VS Code extensions (only inside Codespace)
if command -v code &> /dev/null && [[ -f "$DOTFILES_DIR/vscode/extensions.txt" ]]; then
  echo "▶ Installing VS Code extensions..."
  while read -r ext; do
    [[ -n "$ext" ]] && code --install-extension "$ext" || true
  done < "$DOTFILES_DIR/vscode/extensions.txt"
fi

echo "✅ dotfiles install done"
