#!/usr/bin/env bash
set -euo pipefail

echo "▶ Bootstrapping Codespace dotfiles…"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# 1.  keep OMZ fresh so the built-in uv plugin exists
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  git -C "$HOME/.oh-my-zsh" pull --quiet
fi

# 2.  Symlink tracked files
ln -sf "$DOTFILES_DIR/.zshrc"    "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.aliases"  "$HOME/.aliases"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# 3.  Extra Zsh plugins not shipped with OMZ (clone once)
for repo in \
  "https://github.com/zsh-users/zsh-autosuggestions.git" \
  "https://github.com/zsh-users/zsh-syntax-highlighting.git"
do
  name="${repo##*/}"
  [[ -d "$ZSH_CUSTOM/plugins/$name" ]] || git clone --depth=1 "$repo" "$ZSH_CUSTOM/plugins/$name"
done :contentReference[oaicite:1]{index=1}

# 4.  Python tooling (user site)
python3 -m pip install --user --quiet uv ruff :contentReference[oaicite:2]{index=2}

echo "✅ dotfiles install done"
