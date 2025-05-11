#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Eze's Codespace Dotfiles Bootstrap
# -----------------------------------------------------------------------------

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
VERBOSE=0
DRY_RUN=0

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------
log() {
  [[ $VERBOSE -eq 1 ]] && echo "▶ $*"
}

run() {
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "[DRY RUN] $*"
  else
    log "$*"
    eval "$*"
  fi
}

# -----------------------------------------------------------------------------
# Steps
# -----------------------------------------------------------------------------
install_oh_my_zsh() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "▶ Installing Oh My Zsh…"
    run "sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" \"\" --unattended"
  else
    echo "▶ Updating Oh My Zsh…"
    run "git -C \"$HOME/.oh-my-zsh\" pull --quiet"
  fi
}

link_dotfiles() {
  echo "▶ Symlinking core dotfiles…"
  run "ln -sf \"$DOTFILES_DIR/.zshrc\"       \"$HOME/.zshrc\""
  run "ln -sf \"$DOTFILES_DIR/.zsh_aliases\" \"$HOME/.zsh_aliases\""
  run "ln -sf \"$DOTFILES_DIR/.gitconfig\"   \"$HOME/.gitconfig\""
}

install_plugins() {
  echo "▶ Ensuring Zsh plugins…"
  for repo in \
    "https://github.com/zsh-users/zsh-autosuggestions.git" \
    "https://github.com/zsh-users/zsh-syntax-highlighting.git"
  do
    name="${repo##*/}"
    dest="$ZSH_CUSTOM/plugins/$name"
    if [[ -d "$dest" ]]; then
      log "Plugin $name already present"
    else
      run "git clone --depth=1 \"$repo\" \"$dest\""
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
    run "python3 -m pip install --user pipx"
    run "python3 -m pipx ensurepath"
    # shellcheck source=/dev/null
    run "source \"$HOME/.profile\" || true"
  fi

  for pkg in ruff uv; do
    if command -v "$pkg" &>/dev/null; then
      log "$pkg already installed via pipx"
    else
      run "pipx install $pkg"
    fi
  done
}

install_vscode_exts() {
  if command -v code &>/dev/null && [[ -f "$DOTFILES_DIR/vscode/extensions.txt" ]]; then
    echo "▶ Installing VS Code extensions…"
    while read -r ext; do
      ext_trimmed="$(echo "$ext" | xargs)"
      if [[ -n "$ext_trimmed" ]]; then
        run "code --install-extension \"$ext_trimmed\" || true"
      fi
    done < "$DOTFILES_DIR/vscode/extensions.txt"
  fi
}

# -----------------------------------------------------------------------------
# Argument parsing
# -----------------------------------------------------------------------------
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -v|--verbose) VERBOSE=1 ;;
      -n|--dry-run) DRY_RUN=1 ;;
      -h|--help)
        cat <<EOF
Usage: $(basename "$0") [options]
Options:
  -v, --verbose   Show each command before it runs
  -n, --dry-run   Print actions without executing them
  -h, --help      Show this help message
EOF
        exit 0
        ;;
      *) echo "Unknown option: $1" >&2; exit 1 ;;
    esac
    shift
  done
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
main() {
  parse_args "$@"
  echo "▶ Bootstrapping Eze Codespace dotfiles…"
  install_oh_my_zsh
  link_dotfiles
  install_plugins
  install_python_tools
  install_vscode_exts
  echo "✅ dotfiles install done"
}

main "$@"