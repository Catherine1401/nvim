
-- 1. Cấu hình giao diện cơ bản
vim.opt.number = true          -- Hiện số dòng
vim.opt.relativenumber = true  -- Hiện số dòng tương đối (giúp nhảy dòng nhanh bằng j/k)
vim.opt.termguicolors = true   -- Bật màu True Color (24-bit) cho giao diện đẹp
vim.opt.cursorline = true      -- Highlight dòng hiện tại
-- vim.opt.cursorcolumn = true
vim.opt.wrap = false           -- Không tự xuống dòng (để code dài thì kéo ngang xem cho dễ)
vim.opt.colorcolumn = "80"

-- 2. Cấu hình Indent (Thụt đầu dòng) - Chuẩn cho Flutter/Lua
vim.opt.expandtab = true       -- Dùng dấu cách thay cho Tab
vim.opt.shiftwidth = 2         -- 1 Tab = 2 dấu cách
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true     -- Tự động thụt dòng thông minh

-- 3. Cấu hình tìm kiếm
vim.opt.ignorecase = true      -- Tìm kiếm không phân biệt hoa thường
vim.opt.smartcase = true       -- ...trừ khi cậu gõ chữ hoa

-- 4. Cấu hình hệ thống
vim.opt.clipboard = "unnamedplus" -- Dùng chung clipboard với hệ điều hành (Copy/Paste ra ngoài được)
vim.opt.undofile = true           -- Lưu lịch sử Undo (kể cả khi tắt máy)

-- 5. Cấu hình cửa sổ (Split)
vim.opt.splitright = true      -- Chia màn hình dọc thì cửa sổ mới nằm bên phải
vim.opt.splitbelow = true      -- Chia màn hình ngang thì cửa sổ mới nằm bên dưới

-- 6. Cấu hình cuộn (Scroll)
vim.opt.scrolloff = 8          -- Luôn giữ con trỏ cách mép trên/dưới 8 dòng (để dễ nhìn ngữ cảnh)
vim.opt.sidescrolloff = 8      -- Tương tự với mép trái/phải
vim.opt.hidden = true

-- other config
vim.opt.fileformat = "unix"
vim.opt.fileformats = "unix,dos"
