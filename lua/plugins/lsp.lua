return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
  },

  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    }
  },

  {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "lua_ls",
          "html", "cssls",
          "emmet_language_server","emmet_ls",
          "intelephense", "phpactor",
          "pyright",
        },
      }
    end,
  },


  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- nguồn completion từ LSP
      "hrsh7th/cmp-buffer",   -- gợi ý từ buffer hiện tại
      "hrsh7th/cmp-path",     -- gợi ý path
      "L3MON4D3/LuaSnip",     -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- gợi ý snippet
      "rafamadriz/friendly-snippets",
      "aca/emmet-ls",
    },
  },
}

