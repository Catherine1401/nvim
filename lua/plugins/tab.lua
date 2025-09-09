return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    config = function()
      vim.opt.termguicolors = true  -- bắt buộc để plugin hiển thị màu chính xác
      require("bufferline").setup{
        options = {
          numbers = "ordinal",  -- hiển thị số buffer
          close_command = "bdelete! %d",  -- lệnh đóng buffer
          right_mouse_command = "bdelete! %d",
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 30,
          max_prefix_length = 30,
          tab_size = 21,
          show_buffer_close_icons = true,
          show_close_icon = false,
          show_tab_indicators = true,
          persist_buffer_sort = true,
          separator_style = "thin",  -- kiểu separator
          always_show_bufferline = true,
          diagnostics = "nvim_lsp",   -- chỉ báo lỗi LSP
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            if context.buffer:current() then return "" end
            return ""
          end,
        }
      }
    end,
  }
}
