return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional, cho UI đẹp
    },
    config = function()
      require("flutter-tools").setup {
        flutter_path = vim.fn.exepath("flutter"), -- tìm flutter trong PATH
        widget_guides = { enabled = true },
        closing_tags = { enabled = true, prefix = ">" },
        dev_log = { enabled = true, open_cmd = "tabedit" },
        outline = { auto_open = false },
        lsp = {
          on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, noremap = true, silent = true }
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
          end,
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        },
      }
    end,
  },
}
