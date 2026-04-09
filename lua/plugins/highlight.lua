return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",           -- Bắt buộc với Neovim 0.12
    build = ":TSUpdate",
    lazy = false,

    config = function()
      -- Config mới của nvim-treesitter (main branch)
      require("nvim-treesitter").setup({
        -- 1. Các ngôn ngữ cốt lõi
        ensure_installed = {
          "c", "lua", "vim", "vimdoc", "query",
          "markdown", "markdown_inline",
          -- Thêm "c_sharp" vào đây vì bạn dùng C#
          "c_sharp",
        },

        -- 2. Tự động tải parser khi mở file lạ
        auto_install = true,

        -- 3. Các tính năng khác
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        indent = {
          enable = false,        -- easy-dotnet đang dùng GetCSIndent riêng
        },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<S-space>",
            node_incremental = "<S-space>",
            scope_incremental = false,
            node_decremental = "<esc>",
          },
        },
      })
    end,
  },
}
