-- Auto commands for front-end development
local api = vim.api

-- (Disabled) Auto format on save via LSP. Dùng :Format (Conform) thủ công khi cần

-- Auto install treesitter parsers
api.nvim_create_autocmd("User", {
  pattern = "LazySync",
  callback = function()
    vim.cmd("TSUpdate")
  end,
})

-- Highlight on yank
api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
})

-- Auto resize splits
api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Auto close quickfix
api.nvim_create_autocmd("WinLeave", {
  callback = function()
    if vim.bo.ft == "qf" then
      vim.cmd("pclose")
    end
  end,
})

-- Auto save session
api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.cmd("mksession!")
  end,
})

-- Auto reload on file change
api.nvim_create_autocmd("FocusGained", {
  callback = function()
    vim.cmd("checktime")
  end,
})

-- Auto set filetype
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.jsx" },
  callback = function()
    vim.bo.filetype = "javascriptreact"
  end,
})

api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.tsx" },
  callback = function()
    vim.bo.filetype = "typescriptreact"
  end,
})

-- Auto set commentstring for Vue
api.nvim_create_autocmd("FileType", {
  pattern = "vue",
  callback = function()
    vim.bo.commentstring = "<!-- %s -->"
  end,
})

-- Auto set commentstring for JSX/TSX
api.nvim_create_autocmd("FileType", {
  pattern = { "javascriptreact", "typescriptreact" },
  callback = function()
    vim.bo.commentstring = "{/* %s */}"
  end,
})

-- Auto set commentstring for Dart
api.nvim_create_autocmd("FileType", {
  pattern = "dart",
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

-- Auto set commentstring for Flutter
api.nvim_create_autocmd("FileType", {
  pattern = "dart",
  callback = function()
    vim.bo.commentstring = "// %s"
    -- Enable Flutter specific features
    vim.bo.expandtab = true
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
})
