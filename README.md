# Neovim Configuration for Windows 11

## **Cài đặt nhanh:**

### **1. Chạy script cài đặt:**
```cmd
install-neovim.bat
```

### **2. Script sẽ cài đặt:**
- **Neovim** - Editor chính
- **Node.js LTS** - Runtime cho JavaScript/TypeScript
- **Git** - Để clone plugins
- **Ripgrep & FZF** - Fuzzy finder cho Telescope
- **Python** - Runtime cho một số LSP servers
- **PHP** - Runtime cho PHP LSP server
- **Dart** - Runtime cho Dart/Flutter LSP server
- **Deno** - Runtime cho Deno LSP server
- **Live Server** - Live preview cho web projects

### **3. Sau khi cài đặt:**
```bash
nvim
```

## **Hệ thống tự động:**

### **Lazy Loader:**
- Tự động cài đặt tất cả Neovim plugins
- Quản lý dependencies và updates
- Lazy loading để tối ưu performance

### **Mason:**
- Tự động cài đặt LSP servers
- Tự động cài đặt formatters/linters
- Quản lý tất cả development tools

### **Không cần cài đặt thủ công:**
- ❌ ESLint, Prettier, PHP-CS-Fixer
- ❌ SQL formatters, YAML linters
- ❌ Code beautifiers
- ❌ TypeScript compiler

## **Cấu hình bao gồm:**

### **LSP Servers:**
- TypeScript/JavaScript (tsserver)
- PHP (intelephense)
- Dart/Flutter
- HTML/CSS/JSON
- Vue, Tailwind CSS
- Docker, YAML

### **Formatters & Linters:**
- JavaScript/HTML/CSS (Beautify)
- PHP (php-cs-fixer, phpcs, phpcbf)
- SQL (sqlformat, sqlfluff)
- YAML (yamllint)
- Docker (hadolint)

### **Plugins:**
- File explorer (NvimTree)
- Fuzzy finder (Telescope)
- Git integration (Gitsigns)
- Auto-completion (nvim-cmp)
- Syntax highlighting (Treesitter)
- Status line (Lualine)
- Buffer management (Bufferline)
- **Breadcrumbs navigation** - Hiển thị đường dẫn file và context

## **Lợi ích:**

✅ **Cài đặt nhanh** - Chỉ cài dependencies cần thiết  
✅ **Tự động hoàn chỉnh** - Lazy loader và Mason xử lý mọi thứ  
✅ **Không trùng lặp** - Không cài đặt tools đã có trong Neovim  
✅ **Dễ bảo trì** - Tất cả được quản lý tập trung  
✅ **Performance tối ưu** - Lazy loading plugins  

## **Troubleshooting:**

### **Nếu gặp lỗi:**
1. Chạy `:checkhealth` trong Neovim
2. Chạy `:Mason` để kiểm tra LSP servers
3. Chạy `:Lazy sync` để đồng bộ plugins

### **Kiểm tra trạng thái:**
```vim
:Mason          -- LSP servers và tools
:MasonNullLs    -- Formatters và linters
:Lazy           -- Plugin manager
:checkhealth    -- System health
```

### **Keymaps chính:**
```vim
-- Buffer Management:
<leader>bn      -- Sang buffer tiếp theo
<leader>bp      -- Về buffer trước đó
<leader>bd      -- Chọn và đóng buffer
<leader>bc      -- Đóng buffer hiện tại
<leader>1-9     -- Chuyển đến buffer 1-9

-- Tab Management:
<leader>tn      -- Tạo tab mới
<leader>tc      -- Đóng tab hiện tại
<leader>t[      -- Tab trước
<leader>t]      -- Tab tiếp theo

-- Breadcrumbs:
<leader>bb      -- Toggle breadcrumbs
<leader>br      -- Refresh breadcrumbs

-- File Explorer:
<leader>e       -- Toggle NvimTree
<leader>ot      -- Mở file trong tab mới (NvimTree)
<leader>ff      -- Tìm file (Telescope)
<leader>fg      -- Tìm nội dung (Telescope)
```

## **Lưu ý quan trọng:**

- **KHÔNG** cài đặt thủ công các development tools
- **KHÔNG** cài đặt npm packages global
- **ĐỂ** Lazy loader và Mason tự động xử lý
- **CHỈ** cài đặt system dependencies cần thiết

## **Hỗ trợ:**

Nếu gặp vấn đề, hãy kiểm tra:
1. PowerShell Execution Policy
2. Kết nối internet để clone plugins
3. Quyền truy cập thư mục
4. Node.js và Python đã được cài đặt
