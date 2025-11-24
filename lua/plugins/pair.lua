return {
  -- 1. NVIM-AUTOPAIRS (Tự động đóng ngoặc)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter", -- Tối ưu hiệu năng: Chỉ chạy khi bắt đầu gõ
    opts = {
      check_ts = true,     -- Kích hoạt Treesitter để check ngữ cảnh (tránh đóng ngoặc trong string/comment)
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },

      -- Tính năng Fast Wrap (Bọc nhanh bằng Alt + e)
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
      map_cr = true, -- Map phím Enter để xuống dòng thông minh
    },
    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      autopairs.setup(opts)

      -- Tích hợp an toàn với nvim-cmp (nếu có)
      -- local cmp_status_ok, cmp = pcall(require, "cmp")
      -- if cmp_status_ok then
      --   local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      --   cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      -- end
    end,
  },

  -- 2. NVIM-SURROUND (Thao tác bao quanh)
  {
    "kylechui/nvim-surround",
    version = "*",      -- THEO DOCS: Sử dụng bản ổn định mới nhất (Use for stability)
    event = "VeryLazy", -- Load lười để không làm chậm khởi động
    config = function()
      -- THEO DOCS: Để trống {} để sử dụng cấu hình mặc định cực mạnh (defaults)
      -- Plugin đã tự động map các phím ys, ds, cs rất chuẩn rồi.
      require("nvim-surround").setup({})
    end,
  },
}
