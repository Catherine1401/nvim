return {
  "numToStr/Comment.nvim",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring"
  },
  config = function()
    local pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()

require('Comment').setup({
  --- Add a space between comment and line
  padding = true,
  sticky = true,
  --- Toggler: NORMAL mode
  toggler = {
    line  = "<C-_>",  -- gcc -> <leader>/
    block = "<leader>/"   -- gbc -> <leader>/ (block lẫn line nếu muốn)
  },
  --- Operator-pending mappings (NORMAL + VISUAL)
  opleader = {
    line  = "<C-_>",  -- gc -> <leader>/
    block = "<leader>/"   -- gb -> <leader>/
  },
  --- Extra mappings (gco, gcO, gcA)
  extra = {
    above = "<leader>O",
    below = "<leader>o",
    eol   = "<leader>A",
  },
  mappings = {
    basic = true,
    extra = true,
  },
   pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  ignore = '^$',
})
  end,
}
