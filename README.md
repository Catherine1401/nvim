# Config neovim for flutter (maybe)

## Requirement

- git
- nerd font
- fd
- ripgrep
- fzf
- curl
- python
- nodejs
- gcc
- lua
- luarocks
- flutter
- tree-sitter-cli
- rustup
- rust nigthly
- make

### Recommend install via scoop

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
#install git
scoop install git
# add bucket
scoop bucket add extras
# install font
scoop bucket add nerd-fonts
scoop install JetBrainsMono-NF
# install find tool
scoop install fd
scoop install ripgrep
scoop install fzf
# instal curl
scoop install curl
# install python
scoop install python
# install nodejs
scoop install nodejs
# install gcc
scoop install gcc
# install lua
scoop install lua
scoop install luarocks
# install flutter
scoop install flutter
flutter doctor --android-licenses
# for treesetter
npm install -g tree-sitter-cli
# install rust
scoop install rustup
rustup install nightly
rustup defalut nightly
# install make
scoop install make
# install obsidian
scoop install obsidian
# install neovim
scoop install neovim
cd AppData/Local
git clone https://github.com/Catherine1401/nvim.git
```
