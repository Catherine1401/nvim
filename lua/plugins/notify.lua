return {
  -- 1. NOICE.NVIM (Giữ nguyên cấu hình chuẩn)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = { enabled = true, silent = true },
        signature = { enabled = true, auto_open = { enabled = true, trigger = true } },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      routes = {
        -- Lọc bỏ tin nhắn rác khi lưu file
        {
          filter = { event = "msg_show", kind = "", find = "written" },
          opts = { skip = true },
        },
        -- Đẩy thông báo dài vào popup
        {
          view = "popup",
          filter = { event = "msg_show", min_height = 20 },
        },
      },
      notify = {
        enabled = true,
        view = "notify",
      },
    },
    keys = {
      { "<leader>sn", "", desc = "+noice"},
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"} },
    },
  },

  -- 2. NVIM-NOTIFY (Cấu hình Mặc định & Ổn định)
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      
      -- Sử dụng kiểu render có sẵn đẹp nhất: Tự động xuống dòng và gọn gàng
      render = "default", 
      
      -- Hiệu ứng chuyển động mượt mà
      stages = "fade_in_slide_out",
      
      -- Màu nền tối để hòa vào editor
      background_colour = "#000000",
      
      -- Giới hạn kích thước
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
      
      -- Tự động làm mờ cửa sổ
      on_open = function(win)
        vim.api.nvim_win_set_option(win, "winblend", 10)
      end,
    },
    
    -- Giữ lại phần Highlight này để màu sắc đẹp hơn mặc định (Đỏ/Vàng/Xanh rõ ràng)
    config = function(_, opts)
      require("notify").setup(opts)
      
      vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = "#db4b4b" })
      vim.api.nvim_set_hl(0, "NotifyWARNBorder",  { fg = "#e0af68" })
      vim.api.nvim_set_hl(0, "NotifyINFOBorder",  { fg = "#0db9d7" })
      vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = "#9ece6a" })
      vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = "#d0d0d0" })
      
      vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = "#db4b4b" })
      vim.api.nvim_set_hl(0, "NotifyWARNIcon",  { fg = "#e0af68" })
      vim.api.nvim_set_hl(0, "NotifyINFOIcon",  { fg = "#0db9d7" })
      vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", { fg = "#9ece6a" })
      vim.api.nvim_set_hl(0, "NotifyTRACEIcon", { fg = "#d0d0d0" })
      
      vim.api.nvim_set_hl(0, "NotifyERRORTitle",  { fg = "#db4b4b" })
      vim.api.nvim_set_hl(0, "NotifyWARNTitle",   { fg = "#e0af68" })
      vim.api.nvim_set_hl(0, "NotifyINFOTitle",   { fg = "#0db9d7" })
      vim.api.nvim_set_hl(0, "NotifyDEBUGTitle",  { fg = "#9ece6a" })
      vim.api.nvim_set_hl(0, "NotifyTRACETitle",  { fg = "#d0d0d0" })
    end,
    keys = {
      {
        "<leader>un",
        function() require("telescope").extensions.notify.notify() end,
        desc = "Notify History (Telescope)",
      },
    },
  },
}
