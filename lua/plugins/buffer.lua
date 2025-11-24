return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = { 'BufRead', 'BufNewFile' },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    keys = {
      -- Điều hướng qua lại giữa các tab
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Qua tab trái" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Qua tab phải" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Qua tab trái" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Qua tab phải" },

      -- Các nhóm lệnh đóng buffer (Close commands)
      -- 1. Đóng buffer hiện tại (Quan trọng nhất)
      { "<leader>bd", "<cmd>bdelete<cr>", desc = "Đóng buffer hiện tại (Close Current)" },
      -- Hoặc cậu có thể dùng <leader>x nếu quen tay kiểu VS Code:
      -- { "<leader>x", "<cmd>bdelete<cr>", desc = "Đóng buffer hiện tại" },

      -- 2. Các lệnh đóng hàng loạt
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Đóng TẤT CẢ trừ tab này" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Đóng hết bên phải" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Đóng hết bên trái" },

      -- Các tiện ích khác
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Ghim/Bỏ ghim tab" },
      { "<leader>bs", "<Cmd>BufferLinePick<CR>", desc = "Chọn nhanh tab (Pick)" },
    },

    opts = {
      options = {
        mode = "buffers",
        separator_style = "slant", -- Kiểu vát chéo

        -- === PHẦN CẬU YÊU CẦU: UNDERLINE INDICATOR ===
        -- Tạo đường gạch chân dưới tab đang chọn
        indicator = {
          style = 'underline',
        },

        -- Các cấu hình giao diện khác
        show_buffer_close_icons = true,
        show_close_icon = false,
        modified_icon = "●",

        diagnostics = "nvim_lsp",
        always_show_bufferline = true,

       diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,

        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" }
        },

        numbers = "ordinal",

        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
        },

        sort_by = 'insert_after_current',
      },
    },
  },
}
