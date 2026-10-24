<p align="center">
  <img src="./assets/logo.svg" width="128" alt="HW NVIM logo" />
</p>

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

https://github.com/user-attachments/assets/6b67e714-2c31-4b35-b46d-441809a886d0

<details>
<summary>Chapters</summary>

| Time | Chapter |
|---|---|
| 0:00 | Search |
| 0:18 | Files, buffers and windows |
| 0:41 | Motion and editing |
| 1:00 | Multicursor |
| 1:11 | LSP and diagnostics |
| 1:39 | Completion and AI |
| 1:56 | Git |
| 2:46 | Flutter |
| 3:40 | Debugging |
| 4:33 | Go |
| 4:59 | Notebooks |
| 5:25 | Terminal and Markdown |

</details>

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
