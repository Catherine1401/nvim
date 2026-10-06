-- lua/config/keymaps.lua

local map = vim.keymap.set

-- =======================================================
-- 1. CÁC THAO TÁC CƠ BẢN (GENERAL)
-- =======================================================

-- Thoát nhanh (Quit)
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Thoát Neovim (Quit all)" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
-- map('i', '<Esc>', '<Esc><cmd>w<CR>', { desc = "Save when exiting Insert Mode", silent = true })
map('n', '<C-a>', 'ggVG', { desc = "Chọn toàn bộ file" })
-- map('n', '<C-u', '<C-u>zz')
-- map('n', '<C-d', '<C-d>zz')

-- Tắt highlight tìm kiếm khi bấm Esc (cho đỡ rối mắt)
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Tắt highlight tìm kiếm" })

-- =======================================================
-- 2. ĐIỀU HƯỚNG CỬA SỔ (WINDOW NAVIGATION)
-- =======================================================

-- Di chuyển giữa các cửa sổ bằng Ctrl + h/j/k/l (Thay vì Ctrl+w...)
map("n", "<C-h>", "<C-w>h", { desc = "Qua trái" })
map("n", "<C-j>", "<C-w>j", { desc = "Xuống dưới" })
map("n", "<C-k>", "<C-w>k", { desc = "Lên trên" })
map("n", "<C-l>", "<C-w>l", { desc = "Qua phải" })

map('n', '<leader><Right>', ':vsplit<CR>', { desc = "Chia cửa sổ dọc" })
map('n', '<leader><Down>', ':split<CR>', { desc = "Chia cửa sổ ngang" })

-- Thay đổi kích thước cửa sổ bằng Alt + h/j/k/l
map("n", "<A-k>", "<cmd>resize +2<cr>", { desc = "Tăng chiều cao" })
map("n", "<A-j>", "<cmd>resize -2<cr>", { desc = "Giảm chiều cao" })
map("n", "<A-h>", "<cmd>vertical resize +2<cr>", { desc = "Tăng chiều rộng" })
map("n", "<A-l>", "<cmd>vertical resize -2<cr>", { desc = "Giảm chiều rộng" })

-- =======================================================
-- 3. DI CHUYỂN DÒNG CODE (MOVING LINES) - Cực xịn
-- =======================================================

-- Di chuyển dòng đang chọn lên xuống bằng J/K (Chế độ Visual)
-- Tự động format lại code khi di chuyển
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Chuyển dòng xuống dưới" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Chuyển dòng lên trên" })

-- =======================================================
-- 4. TIỆN ÍCH SOẠN THẢO (EDITING UTILS)
-- =======================================================

-- Giữ nguyên chế độ Visual khi thụt đầu dòng (Indenting)
-- Bình thường bấm < hoặc > xong nó bị thoát visual, cái này giúp cậu bấm liên tục được
map("v", "<", "<gv", { desc = "Thụt lề trái" })
map("v", ">", ">gv", { desc = "Thụt lề phải" })

-- Paste không bị mất nội dung trong Clipboard
-- Khi cậu paste đè lên một chữ, vim mặc định sẽ copy chữ bị đè vào clipboard.
-- Dòng này giúp giữ nguyên cái cậu đang copy.
map("x", "p", [["_dP]], { desc = "Paste không mất clipboard" })

-- Nối dòng (Join lines) nhưng con trỏ đứng yên tại chỗ (Mặc định nó nhảy xuống cuối)
map("n", "J", "mzJ`z", { desc = "Nối dòng (Giữ vị trí con trỏ)" })

-- tree
map('n', '<leader>e', '<cmd>Neotree focus filesystem<CR>', { silent = true, desc = "Mở hoặc focus cây thư mục" })
