<div align="center">

<img src="./assets/logo.svg" alt="HW NVIM" width="620">

<hr>

**[Install](#install) · [Keymaps](#keymaps) · [Plugins](#plugin-list) · [Customize](#things-to-change-on-a-new-machine)**

<p>
  <img src="https://img.shields.io/badge/Neovim-0.11%2B-82aaff?style=for-the-badge&logo=neovim&logoColor=1e2030&labelColor=1e2030" alt="Neovim">
  <img src="https://img.shields.io/badge/Lua-100%25-c099ff?style=for-the-badge&logo=lua&logoColor=1e2030&labelColor=1e2030" alt="Lua">
  <img src="https://img.shields.io/badge/Plugins-56-c3e88d?style=for-the-badge&logo=neovim&logoColor=1e2030&labelColor=1e2030" alt="Plugins">
</p>
<p>
  <a href="https://github.com/Catherine1401/nvim/commits/main"><img src="https://img.shields.io/github/last-commit/Catherine1401/nvim?style=for-the-badge&logo=github&logoColor=c8d3f5&labelColor=1e2030&color=ffc777" alt="Last commit"></a>
  <a href="https://github.com/Catherine1401/nvim/stargazers"><img src="https://img.shields.io/github/stars/Catherine1401/nvim?style=for-the-badge&logo=starship&logoColor=c8d3f5&labelColor=1e2030&color=82aaff" alt="Stars"></a>
  <a href="https://github.com/Catherine1401/nvim/issues"><img src="https://img.shields.io/github/issues/Catherine1401/nvim?style=for-the-badge&logo=gitbook&logoColor=c8d3f5&labelColor=1e2030&color=ff966c" alt="Issues"></a>
  <img src="https://img.shields.io/github/repo-size/Catherine1401/nvim?style=for-the-badge&logo=files&logoColor=c8d3f5&labelColor=1e2030&color=c099ff" alt="Repo size">
</p>

A personal Neovim configuration written entirely in Lua, managed with [lazy.nvim](https://github.com/folke/lazy.nvim).<br>
Built around **Flutter/Dart**, with full support for **.NET (C#)**, **Web (TS/React/Next.js/Tailwind)**,<br>
Python, C/C++, Rust, and Markdown/Obsidian.

</div>

---

## Requirements

**Required**

| Component | Notes |
|---|---|
| Neovim >= 0.11 | `nvim-treesitter` uses the `main` branch, LSP uses the `vim.lsp.config` API |
| git, curl, make, gcc | needed to build `telescope-fzf-native`, `blink.cmp`, `LuaSnip` |
| A Nerd Font | the whole UI relies on icons (JetBrainsMono NF recommended) |
| ripgrep (`rg`) | required by Telescope `find_files` / `live_grep` |
| fd, fzf | faster searching |
| nodejs + npm | `markdown-preview`, plus LSPs/formatters installed via Mason |
| python | Python-based tools installed via Mason (`black`, `isort`) |

**Depending on your stack**

- **Flutter** — Flutter SDK + Dart SDK (`flutter doctor`)
- **.NET** — .NET SDK + `dotnet tool install -g EasyDotnet`
- **Terminal** — `zsh` if available, otherwise `$SHELL`; `lazygit` (optional)
- `tree-sitter-cli`, `luarocks`, `rustup` — only if you need to compile parsers or work with Rust

---

## Install

Repo: **https://github.com/Catherine1401/nvim**

Back up your existing config (if any), then clone:

```bash
# Back up the current config
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# Clone
git clone https://github.com/Catherine1401/nvim.git ~/.config/nvim

nvim
```

Using SSH:

```bash
git clone git@github.com:Catherine1401/nvim.git ~/.config/nvim
```

On first launch, lazy.nvim bootstraps itself and installs every plugin. After that, run:

```vim
:Lazy sync          " sync plugins
:Mason              " check that all LSPs/formatters are installed
:checkhealth        " find missing dependencies
```

> **Note:** `lazy-lock.json` is listed in `.gitignore`, so plugin versions are not pinned across machines.

---

## Directory structure

```
.
├── init.lua                 # Entry point: sets leader = <Space>, loads config.*
├── lua/
│   ├── config/
│   │   ├── lazy.lua         # Bootstraps and sets up lazy.nvim, disables built-in vim plugins
│   │   ├── options.lua      # vim.opt: line numbers, 2-space indent, clipboard, undofile...
│   │   ├── keymaps.lua      # Global keymaps (not tied to any plugin)
│   │   └── autocmds.lua     # Yank highlight, restore cursor, q-to-close, checktime
│   └── plugins/             # One file per plugin group; lazy.nvim imports the whole folder
└── snippets/
    └── custom/              # Personal snippets in VS Code format (currently dart.json)
```

To add a plugin, drop a new `.lua` file into `lua/plugins/` that returns a spec table. Nothing else needs to be registered.

---

## Core options (`config/options.lua`)

- Leader is `<Space>`, relative line numbers, `colorcolumn = 80`, global statusline
- Indentation: 2 spaces, `expandtab`, `smartindent`
- Shares the system clipboard (`unnamedplus`), `undofile` enabled
- New splits open to the right / below, `scrolloff = 8`
- **`lazy = false` is the default** — plugins load at startup unless they declare their own `event` / `keys` / `ft`

---

## Keymaps

Leader is `<Space>`. Press `<leader>` and wait 200 ms for which-key to show hints; `<leader>fk` opens a searchable list of every keymap through Telescope.

### General & windows

| Key | Action |
|---|---|
| `<leader>w` / `<leader>q` | Save / Quit |
| `<C-a>` | Select the whole file |
| `<Esc>` | Clear search highlight |
| `<leader>h/j/k/l` | Move between windows |
| `<leader><Right>` / `<leader><Down>` | Vertical split / Horizontal split |
| `<C-Up/Down/Left/Right>` | Resize the current window |
| `J` / `K` (visual) | Move the selection down / up |
| `<` `>` (visual) | Indent, keeping the selection |
| `p` (visual) | Paste without clobbering the clipboard |

### Files & search (Telescope, Neo-tree, Oil)

| Key | Action |
|---|---|
| `<leader><leader>` | Find files |
| `<leader>fw` | Live grep across the project |
| `<leader>fc` | Grep the word under the cursor |
| `<leader>fb` / `<leader>fo` | Buffers / Recent files |
| `<leader>fh` / `<leader>fk` / `<leader>ft` | Help tags / Keymaps / Colorscheme |
| `<leader>gc` / `<leader>gs` | Git commits / Git status |
| `<leader>e` / `<leader>p` | Open / Close Neo-tree |
| `-` | Open Oil in the parent directory (edit the filesystem like a buffer) |
| `<leader>i` | Open Oil in a floating window |

### Buffers (bufferline)

`<S-h>` / `<S-l>` cycle tabs · `<leader>bd` close · `<leader>bo/br/bl` close others/right/left · `<leader>bp` pin · `<leader>bs` pick

### LSP & code

| Key | Action |
|---|---|
| `gd` / `gD` / `gi` | Definition / Declaration / Implementation |
| `K` / `<C-k>` | Hover / Signature help |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>cf` | Format manually (conform.nvim) |
| `<leader>dt` | Toggle diagnostic virtual text |
| `[c` | Jump to the parent context |

> Virtual text is **off** by default to reduce noise; diagnostics show up in the sign column (`✘ ▲ ⚑ »`).

### Motion (flash.nvim + nvim-spider)

| Key | Action |
|---|---|
| `z` / `Z` | Flash jump / Flash by Treesitter node |
| `r` / `R` (operator/visual) | Remote flash / Treesitter search |
| `w` `e` `b` `ge` | Subword motion (camelCase-aware) |

### Multicursor

`<Up>`/`<Down>` add a cursor above/below · `<leader>n` add a cursor at the next match · `<C-q>` toggle · `<Esc>` clear extra cursors · `ga` add-cursor operator · `<leader>ma` align cursors · `]d`/`[d` add a cursor at the next/previous diagnostic

### Flutter (`<leader>f…`)

| Key | Action |
|---|---|
| `<leader>fr` / `<leader>fq` | Run / Quit app |
| `<leader>fh` / `<leader>fR` | Hot Reload / Hot Restart |
| `<leader>fd` / `<leader>fe` | Pick Device / Emulator |
| `<leader>fo` / `<leader>fl` | Toggle Outline / Log |
| `<leader>fs` | Flutter command palette (Telescope) |

### .NET (`<leader>d…`)

`<leader>db` build · `<leader>dr` run · `<leader>dy` test runner · `<leader>dT` test solution · `<leader>dw` watch · `<leader>da` add NuGet package · `<leader>dp` project view · `<leader>dn` new from template · `<leader>ds` user secrets

### AI (NeoCodeium)

Disabled by default (`enabled = false`); toggle it with `<leader>at`.
In insert mode: `<A-f>` accept suggestion · `<A-w>` accept word · `<A-a>` accept line · `<A-e>`/`<A-r>` cycle suggestions · `<A-c>` clear

### Misc

| Key | Action |
|---|---|
| `<leader>tt` | Toggle terminal (floating, zsh) |
| `<leader>mp` | Preview Markdown in the browser |
| `<leader>cp` / `<leader>cc` / `<leader>ct` | Color picker / Convert color / Toggle color highlighting |
| `<leader>on/oo/os/oq/od/ot` | Obsidian: new / open / search / quick switch / daily / template |
| `<leader>snl/snh/snd` | Noice: last / history / dismiss |
| `<leader>un` | Notification history |

---

## Plugin list

| File | Plugin | Purpose |
|---|---|---|
| `theme.lua` | tokyonight (`moon` style) | Colorscheme |
| `starter.lua` | dashboard-nvim | Start screen (`HW` logo) |
| `status.lua` | lualine | Statusline with clock, Noice integration |
| `buffer.lua` | bufferline | Buffer tabs |
| `tree.lua` | neo-tree | File tree |
| `oil.lua` | oil.nvim | Edit the filesystem as a buffer, fixes imports on rename |
| `search.lua` | telescope + fzf-native | Fuzzy finder |
| `lsp.lua` | nvim-lspconfig, mason, mason-tool-installer, schemastore | LSP plus automatic server/tool installation |
| `autocomplete.lua` | blink.cmp + LuaSnip | Completion (`enter` preset, Tab to select) |
| `snippets.lua` | LuaSnip + friendly-snippets, vim-snippets | Snippet sources |
| `format.lua` | conform.nvim | Formatters (stylua, prettier, black/isort, clang-format…) |
| `html.lua` | nvim-lint | Linters (eslint_d, markdownlint, jsonlint) |
| `highlight.lua` | nvim-treesitter (`main` branch) | Parser installation, Treesitter highlighting (skipped above 200 KB) |
| `indentline.lua` | indent-blankline, mini.indentscope, treesitter-context | Indent guides and sticky scope |
| `flutter.lua` | flutter-tools.nvim + nvim-dap, dressing | Flutter: run, hot reload, closing tags, debugger |
| `bloc.lua` | flutter-bloc.nvim + none-ls | BLoC boilerplate generation |
| `dotnet.lua` | easy-dotnet.nvim | Build/run/test/debug for .NET |
| `web.lua` | nvim-ts-autotag, tailwindcss-colorizer-cmp | Auto-close HTML tags, Tailwind color swatches |
| `jump.lua` | flash.nvim | Label-based jumping |
| `motioninline.lua` | nvim-spider | Subword `w/e/b/ge` |
| `multicursor.lua` | multicursor.nvim | Multiple cursors |
| `selectobject.lua` | mini.ai | Extended text objects (`f` function, `c` class, `t` tag…) |
| `pair.lua` | nvim-autopairs, nvim-surround | Auto pairs and surround operations |
| `comment.lua` | Comment.nvim | `gcc` / `gc` |
| `underlineword.lua` | mini.cursorword | Highlight the word under the cursor |
| `scroll.lua` | neoscroll | Smooth scrolling |
| `notify.lua` | noice.nvim + nvim-notify | Popup cmdline and notifications |
| `whichkey.lua` | which-key.nvim | Keymap hints |
| `terminal.lua` | toggleterm | Floating terminal |
| `markdown.lua` | render-markdown, markdown-preview | Render Markdown in-editor / in the browser |
| `obsidian.lua` | obsidian.nvim | Note vault |
| `colorpicker.lua` | ccc.nvim | Pick and convert color codes |
| `ai.lua` | *(empty)* | Avante.nvim is commented out |
| `center.lua` | *(empty)* | stay-centered.nvim is commented out |
| `neocodeium.lua` | neocodeium | AI code suggestions (off by default) |

---

## LSP & tooling (Mason)

`mason-tool-installer` installs these on startup:

**LSP** — `lua_ls`, `jsonls`, `yamlls`, `vtsls`, `eslint`, `tailwindcss`, `cssls`, `html`, `emmet-language-server`, `pyright`, `marksman`, `clangd`, `rust_analyzer`

**Formatters/Linters** — `prettier`, `stylua`, `shfmt`, `black`, `isort`, `clang-format`, `google-java-format`, `markdownlint`, `eslint_d`, `jsonlint`

`dartls` is managed by `flutter-tools.nvim` and does not go through Mason.

**Format on save is disabled** — uncomment the `format_on_save` block in `lua/plugins/format.lua` to turn it on.

---

## Custom snippets

Personal snippets live in `snippets/custom/` in VS Code format, declared in `package.json`:

```json
{
  "name": "my-snippets",
  "contributes": {
    "snippets": [
      { "language": "dart", "path": "./dart.json" }
    ]
  }
}
```

> The path is **relative to `package.json`**, so it works on any machine — no need to touch it.

---

## Things to change on a new machine

Nothing is hard-coded to a single machine any more. Three values are resolved at runtime, and one is a matter of taste:

1. **Obsidian vault** — `lua/plugins/obsidian.lua` defaults to `~/obsidian`. If your vault lives elsewhere, export `OBSIDIAN_VAULT` instead of editing the file:

   ```bash
   export OBSIDIAN_VAULT="$HOME/Documents/vault"
   ```

2. **Flutter SDK** — `lua/plugins/flutter.lua` derives the SDK path from `flutter` in your `PATH` (`<sdk>/bin/flutter` → `<sdk>`) and hands it to `dartls` as an excluded analysis folder. Nothing to do as long as `flutter` is on your `PATH`.
3. **Shell** — `lua/plugins/terminal.lua` picks `zsh` when it is on your `PATH` and falls back to `vim.o.shell` (`$SHELL`) otherwise. Nothing to do.
4. **`lua/plugins/starter.lua`** — the ASCII logo in the `header` block. Purely cosmetic.
