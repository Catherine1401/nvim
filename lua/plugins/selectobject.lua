return {
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" }, -- Tận dụng query có sẵn
    opts = function()
      local ai = require("mini.ai")
      return {
        -- 1. CẤU HÌNH CƠ BẢN
        n_lines = 500,                   -- Tăng phạm vi tìm kiếm lên 500 dòng (Chuẩn cho Flutter Widget tree)
        search_method = "cover_or_next", -- Tìm cái đang bao quanh, hoặc cái tiếp theo

        -- 2. CẤU HÌNH ĐỐI TƯỢNG (CUSTOM OBJECTS)
        -- Kết hợp sức mạnh của Treesitter vào Mini.ai
        custom_textobjects = {
          -- o: Block/Object (Cấu trúc if, loop, block...)
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),

          -- f: Function (Hàm) - Chuẩn xác hơn mặc định
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),

          -- c: Class (Lớp/Widget)
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),

          -- t: Tag (Thẻ HTML/XML) - Tự động nhận diện thẻ thông minh
          t = { "<([%w%-]%w*)%s*[^>]*>.-</%1>", "^<.->().*()</[^/]->$" },

          -- d: Digit (Số) - Chọn nhanh các con số
          d = { "%f[%d]%d+" },

          -- e: Entire (Toàn bộ) - Chọn cả file hoặc cả buffer
          e = { -- Tương đương ggVG
            { "%f[%S]().*()%f[%s]$", "^.().*()$" },
          },
        },

        -- 3. MAPPING (Giữ nguyên chuẩn mặc định vì đã rất tốt)
        mappings = {
          -- Main
          around = "a",
          inside = "i",

          -- Next/Last (Nhảy tới đối tượng tiếp theo/trước đó)
          -- Ví dụ: dan (delete around next)
          around_next = "an",
          inside_next = "in",
          around_last = "al",
          inside_last = "il",

          -- Di chuyển trỏ (Goto)
          goto_left = "g[",
          goto_right = "g]",
        },
      }
    end,
  },
}
