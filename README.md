# Dotfiles for GitHub Codespaces 🐙🚀

Minimal setup that gives every new Codespace the same Python-friendly shell, VS Code configuration, and global tools.


## Quick Start

1. **Fork / clone** this repo (keep the name `dotfiles`).
2. In **GitHub → Settings → Codespaces → Dotfiles** select the repo and enable **“Automatically install dotfiles”**.
3. Create a **new Codespace** for any project. The first terminal prints a short “Bootstrapping…” message—then everything is ready.


## Contents

```

install.sh            # one-time setup on first boot
.zshrc                # plugins: common-aliases, uv, git, pip, autosuggestions, syntax-highlighting
.aliases              # your handy shortcuts (zsh plugins include a lot already)
.gitconfig            # basic Git identity + aliases
vscode/
├─ extensions.txt   # VS Code extension IDs, one per line
└─ settings.json    # Python-centric editor settings

```


## What You Get

* **Python tools**: `uv`, `ruff`, plus helpers installed to `~/.local`.
* **Zsh extras**: autosuggestions, syntax highlighting, common aliases.
* **VS Code defaults**: on-save format & lint with Ruff, Pylance type hints, pytest integration, autosave, smart Git.


## Customise

* **Aliases / plugins** – edit `.aliases` or the `plugins=( … )` line in `.zshrc`, commit, reopen the Codespace.
* **Python packages** – change the `pip install` line in `install.sh`.
* **VS Code** – export current extensions with  
  `code --list-extensions > vscode/extensions.txt` and copy your `settings.json` to `vscode/`.

---

Made with ☕ and 🐍 by **ezemriv** – happy coding!