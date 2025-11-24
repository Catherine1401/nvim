return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",

    -- Cấu hình chi tiết
    opts = {
      -- 1. Cấu hình Nhãn (Labels)
      -- Tự động gán các ký tự dễ bấm nhất cho các điểm nhảy
      labels = "asdfghjklqwertyuiopzxcvbnm",

      search = {
        -- Tìm kiếm đa cửa sổ (Multi-window)
        -- Cho phép cậu nhảy từ cửa sổ này sang cửa sổ khác chỉ bằng 1 cú bấm
        multi_window = true,
        forward = true,
        wrap = true,
        mode = "exact", -- Tìm chính xác ký tự cậu gõ
      },

      jump = {
        jumplist = true, -- Lưu vị trí nhảy vào Jumplist (để bấm Ctrl+o quay lại được)
        pos = "start",   -- Nhảy tới đầu từ
        history = false,
        register = false,
        nohlsearch = true, -- Tự động tắt highlight sau khi nhảy xong
        autojump = false,
      },

      label = {
        uppercase = false, -- Không dùng chữ hoa cho nhãn (để đỡ phải bấm Shift)
        exclude = "",
        current = true,
        after = true,        -- Hiện nhãn phía sau ký tự tìm thấy
        before = false,
        style = "overlay",   -- Hiển thị nhãn đè lên chữ
        reuse = "lowercase", -- Tái sử dụng nhãn chữ thường
        distance = true,     -- ưu tiên gán nhãn cho các điểm gần con trỏ nhất
        min_pattern_length = 0,
      },

      -- 2. Các chế độ hoạt động (Modes)
      modes = {
        -- Chế độ tìm kiếm thường (/)
        search = {
          enabled = true, -- Kích hoạt Flash khi bấm /
        },

        -- Chế độ ký tự (f, t, F, T)
        char = {
          enabled = true,     -- Nâng cấp f/t mặc định
          jump_labels = true, -- Hiện nhãn nếu có nhiều kết quả trùng nhau
          autohide = false,
          multi_line = false, -- Chỉ tìm trên dòng hiện tại (giữ hành vi Vim chuẩn)
        },

        -- Chế độ Treesitter (S)
        treesitter = {
          labels = "abcdefghijklmnopqrstuvwxyz",
          jump = { pos = "range" }, -- Nhảy và chọn cả vùng (Highlight)
          highlight = {
            backdrop = false,
            matches = false,
          },
        },
      },
    },

    -- 3. Phím tắt (Keymaps)
    keys = {
      -- Nhảy nhanh (Flash Jump)
      {
        "z",
        mode = { "n", "x", "o" },
        function() require("flash").jump() end,
        desc = "Flash Jump (Nhảy nhanh)"
      },

      -- Chọn khối code thông minh (Flash Treesitter)
      {
        "Z",
        mode = { "n", "x", "o" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter (Chọn khối)"
      },

      -- Nhảy từ xa (Remote Flash) - Dùng với Operator pending (y, d, c)
      -- Ví dụ: yr -> nhảy tới chỗ khác copy -> quay lại chỗ cũ paste
      {
        "r",
        mode = "o",
        function() require("flash").remote() end,
        desc = "Remote Flash"
      },

      -- Tìm kiếm Treesitter (Chọn đối tượng như function, class...)
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc = "Treesitter Search"
      },

      -- Bật/Tắt Flash trong lúc đang tìm kiếm bằng /
      {
        "<c-s>",
        mode = { "c" },
        function() require("flash").toggle() end,
        desc = "Toggle Flash Search"
      },
    },
  },
}
