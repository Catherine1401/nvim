<p align="center">
  <img src="./assets/logo.svg" width="128" alt="HW NVIM logo" />
</p>

<h1 align="center">HW NVIM</h1>

<p align="center">
  <em>A personal Neovim config for Flutter, Go and Lua — installed with one command.</em>
</p>

<p align="center">
  <a href="docs/install.md">Install</a> ·
  <a href="docs/keymaps.md">Keymaps</a> ·
  <a href="docs/install.md#health-check">Health check</a> ·
  <a href="docs/structure.md">Structure</a> ·
  <a href="docs/install.md#uninstall">Uninstall</a>
</p>

<p align="center">
  <a href="docs/assets/demo.mp4"><img src="docs/assets/demo.gif" width="720" alt="HW NVIM demo" /></a>
</p>

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Catherine1401/nvim/main/install.sh | bash
```

Linux and macOS, no `sudo`. Details in [docs/install.md](docs/install.md).

## Features

- Flutter and Go: run, hot reload, widget tree, debugging with nvim-dap
- Git: gitsigns hunks, diffview with LSP in diff buffers, Neogit commits
- Telescope search with frecency, Neo-tree, Trouble diagnostics
- AI: Claude Code, Codex and Codeium inline suggestions
- `:checkhealth config` reports missing tools
- Press `<Space>` for which-key; full list in [docs/keymaps.md](docs/keymaps.md)

> Personal config, not a distribution. Expect it to change without notice.

MIT © 2026 huyvv · [License](LICENSE)
