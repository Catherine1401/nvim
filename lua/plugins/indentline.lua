return {
  -- ==========================================================================
  -- 1. INDENT BLANKLINE (Kẻ dọc mờ chỉ dẫn thụt lề)
  -- ==========================================================================
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl", -- Bắt buộc cho bản v3
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      indent = {
        char = "│", -- Ký tự kẻ dọc mảnh
        tab_char = "│",
      },
      scope = { enabled = false }, -- Tắt scope để nhường cho mini.indentscope
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
          "lazy", "mason", "notify", "toggleterm", "lazyterm",
        },
      },
    },
  },

  -- ==========================================================================
  -- 2. MINI INDENTSCOPE (Kẻ dọc sáng hiển thị block hiện tại)
  -- ==========================================================================
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      symbol = "│",
      options = { try_as_border = true },
      draw = {
        delay = 100,
        priority = 2,
        animation = function(s, n) return s / n * 20 end,
      },
      mappings = {
        object_scope = 'mi',
        object_scope_with_border = 'ma',
        goto_top = '[i',
        goto_bottom = ']i',
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
          "lazy", "mason", "notify", "toggleterm", "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- ==========================================================================
  -- 3. TREESITTER CONTEXT (Ghim tiêu đề Widget lên đầu)
  -- ==========================================================================
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      enable = true,
      max_lines = 3, -- Chỉ hiện tối đa 3 dòng context (để không che hết màn hình)
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20, -- Nếu block quá dài thì chỉ hiện 1 dòng
      trim_scope = 'outer',     -- Cắt bớt context ngoài cùng nếu quá nhiều
      mode = 'cursor',          -- Tính context theo vị trí con trỏ
      separator = nil,          -- Không cần đường kẻ ngang ngăn cách (cho thoáng)
      zindex = 20,              -- Độ ưu tiên hiển thị (Z-Index)
    },
    -- Phím tắt nhảy lên context (Theo tài liệu hướng dẫn)
    keys = {
      {
        "[c",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        desc = "Nhảy lên Context cha (Jump to Context)",
      },
    },
  },
}
