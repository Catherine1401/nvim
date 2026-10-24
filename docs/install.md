# Install

## Install or update

```bash
curl -fsSL https://raw.githubusercontent.com/Catherine1401/nvim/main/install.sh | bash
```

Works on Linux (x86_64, arm64) and macOS, needs no `sudo`, and installs into your home directory:

- checks `git`, `curl`, `tar`, `make` and a C compiler; prints the install command if one is missing
- installs Neovim >= 0.12 and the tree-sitter CLI into `~/.local` when they are missing or too old
- clones this repo to `~/.config/nvim` (an existing config is moved to `nvim.bak-<time>`) and installs the plugins

Run the same command again to update. A [Nerd Font](https://www.nerdfonts.com/) is recommended for icons.

## Health check

`:checkhealth config` lists what is missing: required tools, recommended ones (ripgrep, fd, Node.js, Python 3, cargo) and per-feature ones (Go, Flutter, ...).

## Uninstall

```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

Move a backup back (`mv ~/.config/nvim.bak-<time> ~/.config/nvim`) to restore your previous config. Neovim and tree-sitter installed by the script live in `~/.local/share/nvim-release` and `~/.local/bin`.
