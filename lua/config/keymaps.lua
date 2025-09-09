local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- leader
vim.g.mapleader = " "

-- basic
map({ "n", "i" }, "qq", "<ESC>:q<CR>", { silent = true }) -- quit
map({ "n", "i" }, "ww", "<ESC>:w<CR>", { silent = true }) -- save
map({ "n", "i" }, "wq", "<ESC>:wq<CR>", { silent = true }) -- save & quit
map("i", "jj", "<ESC>:w<CR>", { silent = true })         -- switch normal mode
map({ "n", "i" }, "<C-a>", "<ESC>gg<S-v><S-g>")          -- select all
map("v", "<C-c>", "y")                                   -- copy
map({ "n", "i" }, "<C-v>", "<ESC>p")                     -- paste

-- giữ vùng chọn sau khi indent
map("v", ">", ">gv", { silent = true })
map("v", "<", "<gv", { silent = true })

-- window
map({ "n", "i" }, "<C-left>", "<ESC>:vertical resize -2 <CR>", { silent = true }) -- giảm chiều rộng
map({ "n", "i" }, "<C-right>", "<ESC>:vertical resize +2 <CR>", { silent = true }) -- tăng chiều rộng
map({ "n", "i" }, "<C-up>", "<ESC>:resize + 2 <CR>", { silent = true })          -- tăng chiều cao
map({ "n", "i" }, "<C-down>", "<ESC>:resize -2 <CR>", { silent = true })         -- giảm chiều cao

-- terminal
map("t", "jj", "<C-\\><C-n>:ToggleTerm <CR>", { silent = true })
map("t", "<esc>", [[<C-\><C-n>]], { silent = true })
map("n", "tt", ":ToggleTerm <CR>", { silent = true })
map("n", "2tt", ":2ToggleTerm <CR>", { silent = true })
map("n", "3tt", ":3ToggleTerm <CR>", { silent = true })
map("n", "4tt", ":4ToggleTerm <CR>", { silent = true })

-- buffer
map('n', '<leader>bb', ':bnext<CR>', { silent = true })   -- next buffer
map('n', '<leader>bv', ':bprev<CR>', { silent = true })   -- preview buffer
map('n', '<leader>bn', ':bdelete<CR>', { silent = true }) -- delete buffer
map('n', '<leader>1', ':BufferLineGoToBuffer 1<CR>', { silent = true })
map('n', '<leader>2', ':BufferLineGoToBuffer 2<CR>', { silent = true })
map('n', '<leader>3', ':BufferLineGoToBuffer 3<CR>', { silent = true })
map('n', '<leader>4', ':BufferLineGoToBuffer 4<CR>', { silent = true })
map('n', '<leader>5', ':BufferLineGoToBuffer 5<CR>', { silent = true })
map('n', '<leader>6', ':BufferLineGoToBuffer 6<CR>', { silent = true })
map('n', '<leader>7', ':BufferLineGoToBuffer 7<CR>', { silent = true })
map('n', '<leader>8', ':BufferLineGoToBuffer 8<CR>', { silent = true })
map('n', '<leader>9', ':BufferLineGoToBuffer 9<CR>', { silent = true })

-- comment
-- Toggle line comment in NORMAL mode
map("n", "<C-_>", function()
  require("Comment.api").toggle.linewise.current()
end, { noremap = true, silent = true, desc = "Toggle comment (line)" })

-- Toggle line comment in VISUAL mode
map("x", "<C-_>", function()
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { noremap = true, silent = true, desc = "Toggle comment (visual)" })

-- format

map("n", "ff", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format code" })

-- code action

-- Ví dụ keymap cho code action
map("n", "ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "Go to referencse" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implement" })
