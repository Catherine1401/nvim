# Keymap guide

The leader key is `<Space>`. Every leader mapping is at most two keypresses after the leader:
one group key and one action key. No leader mapping is a prefix of another leader mapping, so no leader key waits for a timeout.

Press `<leader>?` to see buffer-local keymaps, or `<leader>fk` to search every keymap.

## Quick reference

| Keys | Action |
|---|---|
| `<leader>w` / `<leader>q` | Save / quit |
| `<leader><leader>` | Find files |
| `<leader>e` | Open or focus file tree |
| `<leader>t` | Toggle terminal |
| `<C-h/j/k/l>` | Move between windows |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `s` | Flash jump |

## Groups

### Find (`f`)
| Keys | Action |
|---|---|
| `<leader><leader>` | Files |
| `fw` | Live grep |
| `fb` | Buffers |
| `fo` | Recent files |
| `fc` | Grep word under cursor |
| `fh` | Help tags |
| `fk` | Keymaps |
| `ft` | Colorscheme |
| `fn` | Notification history |

### Buffer (`b`)
| Keys | Action |
|---|---|
| `bd` | Close buffer |
| `bo` | Close other buffers |
| `bs` | Pick buffer |

### Code (`c`)
| Keys | Action |
|---|---|
| `ca` | Code action (LSP, normal and visual) |
| `cr` | Rename symbol (LSP) |
| `cf` | Format |

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
| `gn` / `gp` | Next / previous hunk |
| `gd` | Diff current file |
| `gb` | Blame current line in a float (works on both diffview sides) |
| `gv` | Diffview (all changes) |
| `gf` | File history |
| `gq` | Close diffview |
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
| `rp` | `pub get` |
| `rm` | Rename symbol |
| `rs` | Flutter commands (Telescope) |

### Misc (`m`)
| Keys | Action |
|---|---|
| `mA` | Multicursor: add all matches |

## Without leader

### Windows
| Keys | Action |
|---|---|
| `<C-h/j/k/l>` | Move to left / down / up / right window |
| `<A-h/j/k/l>` | Resize: narrower / shorter / taller / wider |
| `<leader><Right>` / `<leader><Down>` | Vertical / horizontal split |

### Motion
| Keys | Action |
|---|---|
| `s` / `S` | Flash jump / Flash treesitter |
| `w` `e` `b` `ge` | Spider subword motions (camelCase, snake_case) |
| `<C-u>` `<C-d>` | Half-page scroll (smooth) |
| `<C-b>` `<C-f>` | Page scroll (smooth) |
| `<C-y>` `<C-e>` | Line scroll (smooth) |
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
- Diffview buffers are read-only. The old-revision side is renamed to a sibling path (`lua/config/diff_lsp.lua`) so running LSP clients attach and all LSP keymaps work there. `gf` in diffview unlocks the real file and opens it at the cursor line for editing.
- To check conflicts after changing keymaps, load all plugins in headless Neovim, dump
  `nvim_get_keymap` for each mode, and look for duplicate or prefix-overlapping `lhs`.
