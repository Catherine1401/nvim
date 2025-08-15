-- Keymaps for front-end development
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts) -- Di chuyển sang cửa sổ trái
map("n", "<C-j>", "<C-w>j", opts) -- Di chuyển sang cửa sổ dưới
map("n", "<C-k>", "<C-w>k", opts) -- Di chuyển sang cửa sổ trên
map("n", "<C-l>", "<C-w>l", opts) -- Di chuyển sang cửa sổ phải

-- Better buffer navigation
map("n", "<leader><Tab>", ":BufferLineCycleNext<CR>", opts) -- Sang buffer tiếp theo (leader+Tab)
map("n", "<leader><S-Tab>", ":BufferLineCyclePrev<CR>", opts) -- Về buffer trước đó (leader+Shift+Tab)
map("n", "<leader><BTab>", ":BufferLineCyclePrev<CR>", opts) -- Fallback cho terminal gửi BackTab
map("n", "<leader>]", ":BufferLineCycleNext<CR>", opts) -- Phím thay thế nếu Shift+Tab không nhận
map("n", "<leader>[", ":BufferLineCyclePrev<CR>", opts) -- Phím thay thế nếu Shift+Tab không nhận
map("n", "<leader>bd", ":BufferLinePickClose<CR>", opts) -- Chọn và đóng buffer
map("n", "<leader>bc", ":bdelete<CR>", opts) -- Đóng buffer hiện tại
map("n", "<leader>bC", ":bdelete!<CR>", opts) -- Buộc đóng buffer hiện tại
map("n", "<leader>bo", ":BufferLineCloseOthers<CR>", opts) -- Đóng các buffer khác
map("n", "<leader>ba", ":BufferLineCloseLeft<CR>|:BufferLineCloseRight<CR>", opts) -- Đóng buffer trái + phải
map("n", "<leader>bl", ":BufferLineCloseLeft<CR>", opts) -- Đóng các buffer bên trái
map("n", "<leader>br", ":BufferLineCloseRight<CR>", opts) -- Đóng các buffer bên phải
map("n", "<leader>bt", ":enew<CR>", opts) -- Tạo buffer mới
map("n", "<leader>bp", ":BufferLinePick<CR>", opts) -- Chọn buffer để chuyển đến
map("n", "<leader>bP", ":BufferLineTogglePin<CR>", opts) -- Ghim/Bỏ ghim buffer
map("n", "<leader>b,", ":BufferLineMovePrev<CR>", opts) -- Di chuyển buffer sang trái
map("n", "<leader>b.", ":BufferLineMoveNext<CR>", opts) -- Di chuyển buffer sang phải
map("n", "<leader>bsd", ":BufferLineSortByDirectory<CR>", opts) -- Sắp xếp theo thư mục
map("n", "<leader>bse", ":BufferLineSortByExtension<CR>", opts) -- Sắp xếp theo đuôi file
map("n", "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", opts) -- Chuyển đến buffer 1
map("n", "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", opts) -- Chuyển đến buffer 2
map("n", "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", opts) -- Chuyển đến buffer 3
map("n", "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", opts) -- Chuyển đến buffer 4
map("n", "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", opts) -- Chuyển đến buffer 5
map("n", "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", opts) -- Chuyển đến buffer 6
map("n", "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", opts) -- Chuyển đến buffer 7
map("n", "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", opts) -- Chuyển đến buffer 8
map("n", "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", opts) -- Chuyển đến buffer 9

-- Better search
map("n", "n", "nzzzv", opts) -- Tìm tiếp và căn giữa
map("n", "N", "Nzzzv", opts) -- Tìm trước và căn giữa
map("n", "*", "*zzzv", opts) -- Tìm từ dưới con trỏ (xuống) và căn giữa
map("n", "#", "#zzzv", opts) -- Tìm từ dưới con trỏ (lên) và căn giữa

-- Better indentation
map("v", "<", "<gv", opts) -- Thụt lùi, giữ vùng chọn
map("v", ">", ">gv", opts) -- Thụt tiến, giữ vùng chọn

-- Move lines
map("n", "<A-j>", ":m .+1<CR>==", opts) -- Di chuyển dòng xuống
map("n", "<A-k>", ":m .-2<CR>==", opts) -- Di chuyển dòng lên
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts) -- Di chuyển vùng chọn xuống
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts) -- Di chuyển vùng chọn lên

-- Quick save and quit
map("n", "<leader>w", ":w<CR>", opts) -- Lưu file
map("n", "<leader>q", ":q<CR>", opts) -- Đóng cửa sổ hiện tại
map("n", "<leader>Q", ":qa!<CR>", opts) -- Thoát tất cả không lưu

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts) -- Tìm file
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts) -- Tìm nội dung (grep)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts) -- Danh sách buffers
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts) -- Tìm trong help



-- Diagnostics
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", opts) -- Bật/tắt bảng diagnostics
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", opts) -- Lỗi toàn workspace
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", opts) -- Lỗi của file hiện tại

-- Treesitter
map("n", "<leader>ts", "<cmd>TSBufToggle highlight<cr>", opts) -- Bật/tắt highlight Treesitter cho buffer

-- Git
map("n", "<leader>gs", "<cmd>Git<cr>", opts) -- Trạng thái Git
map("n", "<leader>gc", "<cmd>Git commit<cr>", opts) -- Tạo commit
map("n", "<leader>gp", "<cmd>Git push<cr>", opts) -- Đẩy lên remote

-- Terminal
map("n", "<leader>tt", "<cmd>ToggleTerm<cr>", opts) -- Bật/tắt terminal
map("t", "<Esc>", "<C-\\><C-n>", opts) -- Thoát insert trong terminal

 -- Live Server
 map("n", "<leader>ls", ":LiveServerStart<CR>", opts) -- Bật live-server
 map("n", "<leader>lS", ":LiveServerStop<CR>", opts) -- Tắt live-server

 -- Flutter/Dart commands
 map("n", "<leader>fr", ":FlutterRun<CR>", opts) -- Chạy Flutter app
 map("n", "<leader>fh", ":FlutterHotReload<CR>", opts) -- Hot reload
 map("n", "<leader>fH", ":FlutterHotRestart<CR>", opts) -- Hot restart
 map("n", "<leader>fq", ":FlutterQuit<CR>", opts) -- Dừng Flutter
 map("n", "<leader>fd", ":FlutterDevices<CR>", opts) -- Danh sách thiết bị
 map("n", "<leader>fo", ":FlutterOutline<CR>", opts) -- Cấu trúc Flutter
 map("n", "<leader>fl", ":FlutterLspRestart<CR>", opts) -- Restart LSP Flutter

-- DAP (debug) cơ bản
map("n", "<leader>db", ":lua require('dap').toggle_breakpoint()<CR>", opts) -- Toggle breakpoint
map("n", "<leader>dc", ":lua require('dap').continue()<CR>", opts) -- Continue/Start
map("n", "<leader>di", ":lua require('dap').step_into()<CR>", opts) -- Step into
map("n", "<leader>do", ":lua require('dap').step_over()<CR>", opts) -- Step over
map("n", "<leader>dO", ":lua require('dap').step_out()<CR>", opts) -- Step out
map("n", "<leader>dr", ":lua require('dap').repl.toggle()<CR>", opts) -- Toggle REPL
map("n", "<leader>du", ":lua require('dapui').toggle()<CR>", opts) -- Toggle DAP UI

-- Comment
map("n", "<leader>/", "<cmd>CommentToggle<cr>", opts) -- Bật/tắt comment dòng
map("v", "<leader>/", "<cmd>CommentToggle<cr>", opts) -- Bật/tắt comment vùng chọn

-- Format
map("n", "<leader>f", "<cmd>Format<cr>", opts) -- Format mã nguồn

-- NvimTree file explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", opts) -- Bật/tắt NvimTree
map("n", "<leader>nt", "<cmd>NvimTreeToggle<cr>", opts) -- Bật/tắt NvimTree (alias)
map("n", "<leader>o", "<cmd>NvimTreeFocus<cr>", opts) -- Focus vào NvimTree
map("n", "<leader>ef", "<cmd>NvimTreeFindFile<cr>", opts) -- Tìm file hiện tại trong NvimTree
map("n", "<leader>ec", "<cmd>NvimTreeClose<cr>", opts) -- Đóng NvimTree
map("n", "<leader>er", "<cmd>NvimTreeRefresh<cr>", opts) -- Làm mới NvimTree

-- Tabs management
map("n", "<leader>tn", ":tabnew<CR>", opts) -- Tạo tab mới
map("n", "<leader>tc", ":tabclose<CR>", opts) -- Đóng tab hiện tại
map("n", "<leader>to", ":tabonly<CR>", opts) -- Chỉ giữ tab hiện tại
map("n", "<leader>t[", ":tabprevious<CR>", opts) -- Tab trước
map("n", "<leader>t]", ":tabnext<CR>", opts) -- Tab tiếp theo
map("n", "<leader>t<", ":-tabmove<CR>", opts) -- Di chuyển tab sang trái
map("n", "<leader>t>", ":+tabmove<CR>", opts) -- Di chuyển tab sang phải

-- Better escape
map("i", "jj", "<Esc>", opts) -- Thoát insert (gõ jj)
map("i", "jk", "<Esc>", opts) -- Thoát insert (gõ jk)

-- Clear search
map("n", "<leader>nh", "<cmd>nohlsearch<cr>", opts) -- Xóa highlight tìm kiếm

-- Yank to clipboard
map("n", "<leader>y", '"+y', opts) -- Copy vào clipboard hệ thống
map("v", "<leader>y", '"+y', opts) -- Copy vùng chọn vào clipboard
map("n", "<leader>Y", '"+yg_', opts) -- Copy cả dòng vào clipboard

-- Paste from clipboard
map("n", "<leader>p", '"+p', opts) -- Dán sau con trỏ từ clipboard
map("v", "<leader>p", '"+p', opts) -- Dán giữ vùng chọn từ clipboard
map("n", "<leader>P", '"+P', opts) -- Dán trước con trỏ từ clipboard
map("v", "<leader>P", '"+P', opts) -- Dán trước con trỏ (vùng chọn)

-- Quick splits
map("n", "<leader>sv", "<cmd>vsplit<cr>", opts) -- Tách cửa sổ dọc
map("n", "<leader>sh", "<cmd>split<cr>", opts) -- Tách cửa sổ ngang

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<cr>", opts) -- Tăng chiều cao cửa sổ
map("n", "<C-Down>", "<cmd>resize -2<cr>", opts) -- Giảm chiều cao cửa sổ
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", opts) -- Giảm chiều rộng cửa sổ
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", opts) -- Tăng chiều rộng cửa sổ

