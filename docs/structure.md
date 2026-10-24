# Structure

```
init.lua          # entry point
install.sh        # installer
lua/config/       # options, keymaps, autocmds, lazy.nvim bootstrap, health check, feature modules (diff_*, flutter/)
lua/plugins/      # one file per plugin, auto-imported by lazy.nvim
scripts/check.lua # repo checks (file and function length, keymap conflicts)
docs/             # keymaps, install guide, demo assets
```
