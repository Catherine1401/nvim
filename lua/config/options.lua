local opt = vim.opt
local o = vim.o

-- number
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorcolumn = true

-- tab & index
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- clip board
opt.clipboard = "unnamedplus"
opt.termguicolors = true

-- searching
opt.ignorecase = true
opt.smartcase = true

-- color
opt.termguicolors = true

-- 
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = false
o.linebreak = true
