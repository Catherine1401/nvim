-- Đặt phím Leader là Space (Phím cách) - Chuẩn mực hiện đại
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require('config.lazy')

require('config.keymaps')
require('config.options')
require('config.autocmds')
