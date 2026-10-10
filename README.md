<div align="center">

<img src="./assets/logo.svg" alt="HW NVIM" width="620">

</div>

Personal Neovim configuration in Lua, managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

> Personal config, not a distribution. Expect it to change without notice.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Catherine1401/nvim/main/install.sh | bash
```

Works on Linux (x86_64, arm64) and macOS, needs no `sudo`, and installs into your home directory:

- checks `git`, `curl`, `tar`, `make` and a C compiler; prints the install command if one is missing
- installs Neovim >= 0.12 and the tree-sitter CLI into `~/.local` when they are missing or too old
- clones this repo to `~/.config/nvim` (an existing config is moved to `nvim.bak-<time>`) and installs the plugins

Run the same command again to update. A [Nerd Font](https://www.nerdfonts.com/) is recommended for icons.

## Check

`:checkhealth config` lists what is missing: required tools, recommended ones (ripgrep, fd, Node.js, Python 3, cargo) and per-feature ones (Go, Flutter, ...).

## Structure

```
init.lua          # entry point
install.sh        # installer
lua/config/       # options, keymaps, autocmds, lazy.nvim bootstrap, health check
lua/plugins/      # one file per plugin, auto-imported by lazy.nvim
```

Press `<Space>` (the leader) to browse keymaps with which-key; the full list is in [docs/keymaps.md](docs/keymaps.md).

## License

[MIT](LICENSE)
