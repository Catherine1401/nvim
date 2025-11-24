return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    branch = "master",
    
    config = function()
      require("nvim-treesitter.configs").setup({
        -- 1. CHỈ GIỮ LẠI CÁC NGÔN NGỮ CỐT LÕI CỦA EDITOR
        -- (Cậu không cần liệt kê dart, json, yaml... ở đây nữa)
        ensure_installed = {
          "c", "lua", "vim", "vimdoc", "query", -- Cần thiết cho Neovim chạy ổn định
          "markdown", "markdown_inline"         -- Cần thiết cho Dashboard và file README
        },

        -- 2. TỰ ĐỘNG TẢI (MAGIC SWITCH)
        -- Đây là cái cậu cần: Mở file lạ -> Tự động tải parser
        auto_install = true, 

        -- 3. CÁC CẤU HÌNH KHÁC (Giữ nguyên)
        sync_install = false, -- Tải ngầm, không treo máy
        
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        indent = { enable = true },

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
