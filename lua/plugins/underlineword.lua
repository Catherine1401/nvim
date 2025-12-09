return {
  {
    "echasnovski/mini.cursorword",
    version = false, -- Luôn dùng bản mới nhất (Main branch) theo khuyến nghị của docs
    event = { "BufReadPre", "BufNewFile" }, -- Chỉ tải khi mở file để tiết kiệm tài nguyên
    
    -- Cấu hình chính (Options)
    opts = {
      -- Độ trễ (mili giây) trước khi highlight
      -- 100ms là con số cân bằng nhất: đủ nhanh để thấy ngay, đủ chậm để không nháy khi cuộn trang
      delay = 100,
    },

    config = function(_, opts)
      -- 1. Khởi động plugin
      require("mini.cursorword").setup(opts)

      -- 2. Tinh chỉnh nâng cao (Full Config)
      -- Tự động tắt highlight ở các loại cửa sổ không cần thiết để tránh rối mắt
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",        -- File hướng dẫn
          "alpha",       -- Dashboard cũ
          "dashboard",   -- Dashboard mới
          "neo-tree",    -- Cây thư mục
          "Trouble",     -- Bảng lỗi
          "trouble",
          "lazy",        -- Trình quản lý plugin
          "mason",       -- Trình quản lý gói
          "notify",      -- Thông báo
          "toggleterm",  -- Terminal
          "lazyterm",
          "TelescopePrompt", -- Cửa sổ tìm kiếm
          "markdown",    -- (Tùy chọn) Tắt trong markdown nếu thấy rối
        },
        callback = function()
          -- Biến chuẩn của mini.nvim để tắt tính năng cho buffer hiện tại
          vim.b.minicursorword_disable = true
        end,
      })
      
      -- (Tùy chọn) Tắt highlight khi vào chế độ Terminal
      -- Mặc dù docs nói nó tự động tắt, nhưng thêm vào cho chắc chắn
      vim.api.nvim_create_autocmd("TermEnter", {
        callback = function()
          vim.b.minicursorword_disable = true
        end,
      })
    end,
  },
}
