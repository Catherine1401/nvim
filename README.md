<div align="center">

<img src="./assets/logo.svg" alt="HW NVIM" width="620">

</div>

Personal Neovim configuration in Lua, managed with [lazy.nvim](https://github.com/folke/lazy.nvim).

> Personal config, not a distribution. Expect it to change without notice.

## Requirements

- Neovim >= 0.11
- git, make, a C compiler
- [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd)
- Node.js and npm (LSPs and formatters installed via Mason)
- A [Nerd Font](https://www.nerdfonts.com/)

## Install

```bash
git clone https://github.com/Catherine1401/nvim.git ~/.config/nvim
nvim
```

Plugins install on first launch, or headless:

```bash
nvim --headless "+Lazy! sync" +qa
```

Then run `:checkhealth` to find missing dependencies.

## Structure

```
init.lua          # entry point
lua/config/       # options, keymaps, autocmds, lazy.nvim bootstrap
lua/plugins/      # one file per plugin, auto-imported by lazy.nvim
snippets/         # personal snippets
```

Press `<Space>` (the leader) to browse keymaps with which-key.

## Contributing

Issues and pull requests are welcome, but this is a personal config, so changes may not be merged.

## License

[MIT](LICENSE)
