# Neovim Configuration for Front-End Development

Cấu hình Neovim tối ưu cho front-end development với nhiều plugins hữu ích và cấu hình tự động.

## 🚀 Tính năng chính

### 📁 File Explorer & Navigation
- **NvimTree**: File explorer với icons đẹp
- **Telescope**: Fuzzy finder mạnh mẽ
- **Project.nvim**: Quản lý project tự động

### 🛠️ LSP & Completion
- **Mason**: Quản lý LSP servers tự động
- **nvim-cmp**: Completion engine
- **LuaSnip**: Snippets engine
- **Friendly-snippets**: Snippets cho nhiều ngôn ngữ

### 🎨 UI & Experience
- **Catppuccin**: Theme đẹp và modern
- **Lualine**: Status line
- **Bufferline**: Tab bar
- **Indent-blankline**: Indent guides
- **Noice**: UI improvements

### 🔧 Development Tools
- **Treesitter**: Syntax highlighting nâng cao
- **Gitsigns**: Git integration
- **Comment.nvim**: Comment/uncomment
- **Autopairs**: Auto pairs brackets
- **Surround**: Surround text objects
- **ToggleTerm**: Terminal integration

### 📝 Formatting & Linting
- **Conform.nvim**: Auto formatting
- **nvim-lint**: Linting
- **Prettier**: Code formatting
- **ESLint**: JavaScript/TypeScript linting

### 🎯 Front-End Specific
- **TypeScript/JavaScript**: Full LSP support
- **Vue**: Vue.js support
- **Tailwind CSS**: Tailwind CSS IntelliSense
- **Emmet**: HTML/CSS abbreviations
- **HTML/CSS**: Enhanced support

## 📦 Cài đặt

### Yêu cầu hệ thống
- Neovim 0.8.0+
- Git
- Node.js (cho LSP servers)
- Ripgrep (cho Telescope)

### Cài đặt Neovim
```bash
# Windows (Chocolatey)
choco install neovim

# macOS (Homebrew)
brew install neovim

# Linux
sudo apt install neovim  # Ubuntu/Debian
sudo dnf install neovim  # Fedora
```

### Cài đặt cấu hình
1. Clone hoặc copy cấu hình vào thư mục Neovim:
```bash
# Windows
%LOCALAPPDATA%\nvim\

# macOS/Linux
~/.config/nvim/
```

2. Khởi động Neovim và chờ plugins tự động cài đặt:
```bash
nvim
```

## ⌨️ Keymaps

### Navigation
- `<Space>`: Leader key
- `<C-h/j/k/l>`: Di chuyển giữa windows
- `<S-h/l>`: Di chuyển giữa buffers (BufferLine)
- `<leader>1-9`: Chuyển đến buffer số 1-9
- `<leader>bp`: Chọn buffer để chuyển đến
- `<leader>ff`: Tìm file
- `<leader>fg`: Tìm text
- `<leader>fb`: Danh sách buffers

### LSP
- `gd`: Go to definition
- `gr`: Go to references
- `K`: Hover
- `<leader>ca`: Code actions
- `<leader>rn`: Rename

### Diagnostics
- `[d`: Previous diagnostic
- `]d`: Next diagnostic
- `<leader>e`: Show diagnostic in float window
- `<leader>xx`: Toggle Trouble diagnostics
- `<leader>xw`: Show workspace diagnostics
- `<leader>xd`: Show document diagnostics

### Git
- `<leader>gs`: Git status
- `<leader>gc`: Git commit
- `<leader>gp`: Git push

### Terminal
- `<leader>tt`: Toggle terminal
- `<C-\>`: Toggle terminal (alternative)

### File Operations
- `<leader>e`: Toggle file explorer
- `<leader>ef`: Find current file in explorer
- `<leader>ec`: Close file explorer
- `<leader>er`: Refresh file explorer
- `<leader>w`: Save file
- `<leader>q`: Quit
- `<leader>f`: Format code

### NvimTree (File Explorer)
**Global keymaps:**
- `<leader>e`: Toggle NvimTree
- `<leader>ef`: Find current file in tree
- `<leader>ec`: Close NvimTree
- `<leader>er`: Refresh NvimTree

**Inside NvimTree:**
- `<CR>` hoặc `o`: Open file
- `<Tab>`: Preview file
- `<C-v>`: Open in vertical split
- `<C-x>`: Open in horizontal split
- `<C-t>`: Open in new tab
- `a`: Create new file/folder
- `d`: Delete file/folder
- `r`: Rename file/folder
- `c`: Copy file/folder
- `x`: Cut file/folder
- `p`: Paste file/folder
- `y`: Copy filename
- `Y`: Copy relative path
- `gy`: Copy absolute path
- `-`: Go to parent directory
- `<C-]>`: Change root to current node
- `R`: Refresh tree
- `q`: Close tree
- `H`: Toggle hidden files
- `I`: Toggle git ignore files
- `f`: Filter files
- `F`: Clear filter
- `E`: Expand all
- `W`: Collapse all
- `g?`: Show help

### Comments
- `<leader>/`: Toggle comment

### Other
- `jj` hoặc `jk`: Escape từ insert mode
- `<leader>nh`: Clear search highlight
- `<leader>y`: Copy to clipboard
- `<leader>p`: Paste from clipboard

## 🔧 Cấu hình

### Tự động format
Code sẽ tự động format khi save cho các file:
- JavaScript/TypeScript
- Vue
- CSS/SCSS
- HTML
- JSON
- Markdown

### LSP Servers
Các LSP servers sẽ tự động cài đặt:
- TypeScript/JavaScript (tsserver)
- HTML (html)
- CSS (cssls)
- JSON (jsonls)
- ESLint (eslint)
- Tailwind CSS (tailwindcss)
- Vue (vue_language_server)
- Emmet (emmet_ls)

### Treesitter Parsers
Các parsers sẽ tự động cài đặt:
- javascript, typescript, tsx, jsx
- html, css, scss
- json, yaml
- vue, lua, vim
- bash, markdown

## 🎨 Themes

Mặc định sử dụng theme **Catppuccin**. Bạn có thể thay đổi trong file `lua/core/plugins.lua`:

```lua
{
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme "catppuccin"
  end,
}
```

## 📁 Cấu trúc thư mục

```
nvim/
├── init.lua              # File chính
├── lua/
│   └── core/
│       ├── options.lua   # Cấu hình options
│       ├── keymaps.lua   # Keymaps
│       ├── plugins.lua   # Plugins configuration
│       └── lsp.lua       # LSP configuration
└── README.md             # Hướng dẫn này
```

## 🚀 Tips & Tricks

### Tối ưu hiệu suất
- Sử dụng `:Lazy sync` để cập nhật plugins
- Sử dụng `:TSUpdate` để cập nhật Treesitter parsers
- Sử dụng `:Mason` để quản lý LSP servers
- Tắt `lazyredraw` để tránh xung đột với Noice
- Sử dụng `:Lazy clean` để dọn dẹp plugins không sử dụng

### Debug
- `:checkhealth`: Kiểm tra sức khỏe Neovim
- `:Lazy log`: Xem log của lazy.nvim
- `:LspInfo`: Thông tin LSP

### Customization
- Thêm plugins: Chỉnh sửa `lua/core/plugins.lua`
- Thay đổi keymaps: Chỉnh sửa `lua/core/keymaps.lua`
- Tùy chỉnh options: Chỉnh sửa `lua/core/options.lua`

## 🤝 Contributing

Nếu bạn muốn đóng góp, hãy:
1. Fork repository
2. Tạo feature branch
3. Commit changes
4. Push to branch
5. Tạo Pull Request

## 📄 License

MIT License - xem file LICENSE để biết thêm chi tiết.

## 🙏 Credits

Cấu hình này được xây dựng dựa trên:
- [LazyVim](https://github.com/LazyVim/LazyVim)
- [NvChad](https://github.com/NvChad/NvChad)
- [AstroNvim](https://github.com/AstroNvim/AstroNvim)

Cảm ơn các dự án tuyệt vời này!
