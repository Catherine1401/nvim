return {
  {
    "chrisgrieser/nvim-spider",
    lazy = true, -- Chỉ tải khi bấm phím (Lazy load)

    keys = {
      -- Thay thế phím w, e, b, ge mặc định bằng nvim-spider
      -- Áp dụng cho các chế độ: Normal (n), Operator-pending (o), Visual (x)
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-w (Next Subword)"
      },
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-e (End Subword)"
      },
      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-b (Prev Subword)"
      },
      {
        "ge",
        "<cmd>lua require('spider').motion('ge')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-ge (End Prev Subword)"
      },
    },

    -- Cấu hình (Optional)
    -- Tớ để mặc định vì tác giả đã tinh chỉnh rất tốt rồi
    opts = {
      skipInsignificantPunctuation = true, -- Bỏ qua dấu câu vô nghĩa (VD: . , ;) giúp đi nhanh hơn
      subwordMovement = true,              -- Bật tính năng nhảy theo từ con (camelCase)
      consistentOperatorPending = false,   -- Giữ hành vi xóa (dw) giống Vim gốc
    },
  },
}
