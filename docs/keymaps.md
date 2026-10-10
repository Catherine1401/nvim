# Keymap guide

The leader key is `<Space>`. Every leader mapping is at most two keypresses after the leader:
one group key and one action key. No leader mapping is a prefix of another leader mapping, so no leader key waits for a timeout.

Press `<leader>?` to see buffer-local keymaps, or `<leader>fk` to search every keymap.

## Quick reference

| Keys | Action |
|---|---|
| `<leader>w` / `<leader>q` | Save / quit all |
| `<leader><leader>` | Find files (most recently used first) |
| `<leader>e` | Open or focus file tree |
| `<leader>t` | Toggle terminal |
| `<C-h/j/k/l>` | Move between windows |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `s` | Flash jump |

## Groups

### Find (`f`)
| Keys | Action |
|---|---|
| `<leader><leader>` | Files (frecency) |
| `fw` | Live grep (recently used files first) |
| `fb` | Buffers |
| `fo` | Recent files |
| `fc` | Grep word under cursor |
| `fh` | Help tags |
| `fk` | Keymaps |
| `ft` | Colorscheme |

To search only some folders of a project, put a whitelist `.ignore` file at its root (ripgrep reads it with higher priority than `.gitignore`, so `<leader><leader>`, `fw` and `fc` follow it; so does any other `rg` run in that folder):

```
/*
!/lib/
!/docs/
!/.docs/
!/.docs/**
```

`/*` hides everything at the root and each `!/folder/` brings one back. Add `!/folder/**` as well when `.gitignore` only excludes a subfolder of it (like `.docs/learn/`).
| `fn` | Notification history |

### Buffer (`b`)
| Keys | Action |
|---|---|
| `bd` | Close buffer |
| `bo` | Close other buffers |
| `bs` | Pick buffer |

### Diagnostics (`d`)
| Keys | Action |
|---|---|
| `dd` | Workspace diagnostics (Trouble) |
| `db` | Buffer diagnostics (Trouble) |
| `dt` | Toggle diagnostic virtual text |

### Git (`g`)
| Keys | Action |
|---|---|
| `gg` | Neogit |
| `gc` / `gs` | Commits / status (Telescope) |
| `ga` / `gr` | Stage / reset hunk |
| `gn` / `gp` | Next / previous hunk (uses `]c` / `[c` in diffview buffers of a commit) |
| `gd` | Diff current file |
| `gb` | Blame current line in a float (works on both diffview sides) |
| `gv` | Diffview of the working tree (reuses the open one; never reuses a commit view) |
| `gx` | Resolve merge conflicts (Diffview 3-way, only when conflicts exist) |
| `gf` | File history |
| `gq` | Close every open diffview, from any tab |
| `gz` | Toggle full-file view in diff |
| `gw` / `gW` | Switch or delete / create worktree |

### Harpoon (`h`)
| Keys | Action |
|---|---|
| `ha` | Add file |
| `hh` | Menu |
| `<leader>1` to `<leader>4` | Jump to file 1-4 |

### Claude Code (`a`)
| Keys | Action |
|---|---|
| `ac` | Toggle Claude |
| `af` | Focus Claude |
| `am` | Select model |
| `ab` | Add current buffer |
| `as` | Send selection (visual) / add file (file tree) |
| `aa` / `ad` | Accept / deny diff |
| `at` | Toggle NeoCodeium |

### Codex (`o`)
| Keys | Action |
|---|---|
| `oc` | Toggle chat |
| `ob` | Add current file |
| `os` | Add selection (visual) |
| `od` | Add diagnostic |
| `op` | Compose context |
| `or` | Open pending request |
| `oi` | Interrupt turn |
| `oq` | Stop app-server |

### Flutter (`r`)
| Keys | Action |
|---|---|
| `rr` / `rq` | Run / quit app |
| `rt` / `rh` | Hot restart / hot reload |
| `rd` / `re` | Devices / emulators |
| `ro` | Toggle outline |
| `rl` / `rz` | Toggle / clear log |
| `ri` | Toggle inspect widget |
| `rw` | Open DevTools |
| `rg` | Toggle the widget tree of the running app, listing only widgets created by project code (framework, Flutter SDK and package widgets are hidden; their project children attach to the nearest project ancestor). In the tree: `<CR>` jump to the widget source (focus moves to the code window) and highlight it on the device, `<Tab>` fold, `i` inspect, `z` / `Z` zoom into / out of a subtree, `s` switch UI isolate (when the app has several), `r` refresh, `q` close. Moving the tree cursor only highlights that widget on the device (no code navigation); picking a widget on the device selects it in the tree and shows its source |
| `rp` | `pub get` |
| `rm` | Rename symbol |
| `rs` | Flutter commands (Telescope) |

### Go (`j`, Go buffers only)
| Keys | Action |
|---|---|
| `jt` | Run the test under the cursor (failures go to quickfix) |
| `jf` | Run the tests of the current file |
| `jp` | Run the tests of the current package |

`gopls` is started by go.nvim and uses the LSP keymaps above: `gd` definition, `gi` implementation, `K` signature and docs, `grr` usages, `grn` rename across files, `gra` code actions (Extract variable, Extract function, Inline call). Saving a Go file runs `goimports` (format plus imports).

### Debug (`k`)
| Keys | Action |
|---|---|
| `kb` / `kB` | Toggle breakpoint / conditional breakpoint |
| `kl` / `kx` | List all breakpoints in the quickfix window / clear all breakpoints |
| `kc` | Start or continue debugging |
| `kn` / `ki` / `ko` | Step over / into / out |
| `ku` | Toggle the debug UI (scopes, stacks, breakpoints, watches, console) |
| `kr` | Toggle the debug REPL |

When a session stops at a breakpoint, a notification names the file and line (press `kc` to continue) and nvim jumps to the tab showing that source, so a stopped app is never hidden behind the Flutter log tab. On Android, starting a Flutter session first marks the app as "being debugged" (`adb shell am set-debug-app --persistent <applicationId>`, undo with `adb shell am clear-debug-app`), so Android does not show the "isn't responding" dialog or kill the app while it is paused at a breakpoint. Breakpoints can be set or cleared while the app is running; they take effect the next time that line executes. The UI opens only when a session stops at a breakpoint (a plain `FlutterRun` through DAP does not open it) and closes when the session ends. Go uses `:GoDebug` (go.nvim, `dlv`); Dart/Flutter uses the launch configuration from flutter-tools.

### Misc (`m`)
| Keys | Action |
|---|---|
| `mA` | Multicursor: add all matches |
| `mr` | Toggle rendered Markdown view (raw by default; Markdown files only) |

## Without leader

### Windows
| Keys | Action |
|---|---|
| `<C-h/j/k/l>` | Move to left / down / up / right window |
| `<A-h/j/k/l>` | Resize: wider / shorter / taller / narrower |
| `<leader><Right>` / `<leader><Down>` | Vertical / horizontal split |

### Motion
| Keys | Action |
|---|---|
| `s` / `S` | Flash jump / Flash treesitter |
| `w` `e` `b` `ge` | Spider subword motions (camelCase, snake_case) |
| `<C-u>` `<C-d>` | Half-page scroll (smooth) |
| `<C-b>` `<C-f>` | Page scroll (smooth) |
| `<C-y>` `<C-e>` | Line scroll (smooth) |
| `zh` `zl` / `zH` `zL` | Horizontal scroll 10% / half window width (smooth; a count scrolls that many columns) |
| `zt` `zz` `zb` | Align cursor line to top / center / bottom |
| `[c` | Jump to parent treesitter context |
| `gd` `gD` `gi` `K` | LSP definition / declaration / implementation / hover |

### Editing
| Keys | Action |
|---|---|
| `<C-a>` | Select whole file |
| `<Esc>` | Clear search highlight |
| `J` (normal) | Join lines, cursor stays |
| `J` / `K` (visual) | Move selected lines down / up |
| `<` / `>` (visual) | Indent and keep selection |
| `p` (visual) | Paste without overwriting the register |
| `Z` / `gZ` (visual) | Surround selection / surround lines |
| `gc` / `gb` | Comment line / block (operator) |
| `grn` / `gra` / `grf` | LSP rename / code action (Neovim defaults) / format (formatter, falls back to LSP; normal and visual) |
| `q` | Close help, quickfix, man, notify and similar windows |
| `<S-Enter>` (command line) | Redirect the command output to a split (Noice) |

### Insert mode
| Keys | Action |
|---|---|
| `<A-f>` | NeoCodeium: accept suggestion |
| `<A-w>` / `<A-a>` | Accept word / line |
| `<A-e>` / `<A-r>` | Next / previous suggestion |
| `<A-c>` | Clear suggestion |
| `<C-l>` / `<C-h>` | Snippet: next / previous placeholder |

### Terminal
| Keys | Action |
|---|---|
| `<Esc>` | Leave terminal mode; then `<leader>t` hides the terminal |

## Multicursor

| Keys | Action |
|---|---|
| `<Up>` / `<Down>` | Add cursor above / below |
| `<M-Up>` / `<M-Down>` | Skip cursor above / below |
| `<leader>n` / `<leader>N` | Add cursor at next / previous match |
| `<leader>,` / `<leader>S` | Skip next / previous match |
| `<C-q>` | Toggle cursor at current position |
| `ga` + motion | Add cursors with an operator (e.g. `gaip`) |
| `<Ctrl>`+click | Add or remove cursor with the mouse |

While several cursors exist:

| Keys | Action |
|---|---|
| `<Left>` / `<Right>` | Select previous / next cursor |
| `<leader>x` | Delete main cursor |
| `<Esc>` | Re-enable cursors, or clear extra cursors |

## Notes

- Marks use the default `marks.nvim` mappings (`m` plus a key, `dm` plus a key).
- `gc`, `gb`, `ys` and `yS` are operators and always wait for the next key.
- Diffview buffers are read-only. The old-revision side is renamed to a sibling path (`lua/config/diff_lsp.lua`) so running LSP clients attach and all LSP keymaps work there. `gf` in diffview opens the real file at the cursor line for editing; `Ctrl-o` walks back through that file's jumplist and finally returns to the exact diffview window and cursor where `gf` was pressed (each `gf` remembers its own origin, so repeated `gv` → `gf` nest correctly). The real file is locked only while its diffview tab is current, so it stays editable in the edit tab and its LSP keymaps are restored when you switch back. `gf` never overwrites a scratch tab such as the Flutter log (`<leader>rl`): it opens the file in the previous tab that holds a real file window, or in a new tab when there is none. Diffview windows start with an empty jumplist, so `Ctrl-o` inside diffview never swaps the diff window to an unrelated buffer.
- Merge conflicts: `:DiffviewOpen` shows OURS | result | THEIRS. The result (middle) stays editable; `<leader>co` / `ct` / `cb` / `ca` pick ours / theirs / base / all for the block under the cursor, `<leader>cO` / `cT` / `cB` / `cA` for the whole file, `]x` / `[x` jump between conflicts (diffview buffers only). If the result cursor is outside a block, the block keys jump to the next block and notify instead of acting; press again to apply.
- Vietnamese input (ibus-bamboo): `im-select.nvim` (`lua/plugins/im_select_nvim.lua`) switches the ibus engine to `xkb:us::eng` when you leave Insert mode (and once at startup), so Normal-mode keymaps are never processed by the Vietnamese engine; entering Insert restores the engine you were using, and quitting nvim restores it too. Opening the command line does not touch the engine. ibus engines are global, so while nvim sits in Normal mode other windows also see the English engine until you enter Insert or quit.
- To check conflicts after changing keymaps, load all plugins in headless Neovim, dump
  `nvim_get_keymap` for each mode, and look for duplicate or prefix-overlapping `lhs`.
