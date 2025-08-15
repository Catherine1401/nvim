-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load core configurations
require("core.options")
require("core.keymaps")
require("core.plugins")
require("core.autocmds")

-- Auto commands for better UX
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
})

-- (Disabled) Auto format on save via LSP to avoid unwanted formatters
-- Use :Format manually to trigger Beautify/Conform

-- Auto install treesitter parsers
vim.api.nvim_create_autocmd("User", {
  pattern = "LazySync",
  callback = function()
    vim.cmd("TSUpdate")
  end,
})
