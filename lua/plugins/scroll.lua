return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  config = function()
    local neoscroll = require("neoscroll")

    -- 1. Cấu hình cơ bản (Setup)
    neoscroll.setup({
      hide_cursor = false,         -- Ẩn con trỏ khi cuộn cho đỡ rối mắt
      stop_eof = true,             -- Dừng lại khi hết file
      respect_scrolloff = false,   -- Cuộn mượt qua cả vùng scrolloff
      cursor_scrolls_alone = true, -- Con trỏ vẫn cuộn kể cả khi màn hình kịch trần/sàn
      easing = "cubic",            -- Quan trọng: Hiệu ứng nhanh dần -> chậm dần (tự nhiên nhất)

      -- Hook: Tắt 'cursorline' (dòng highlight) khi cuộn để mượt hơn
      pre_hook = function() vim.opt.cursorline = false end,
      post_hook = function() vim.opt.cursorline = true end,
    })

    -- 2. Phím tắt tùy chỉnh (Custom Mappings)
    -- Tớ cấu hình thời gian riêng cho từng loại cuộn để mắt cậu dễ theo dõi
    local keymap = {
      -- Ctrl + u / d (Nửa trang): 250ms là vừa đủ để mắt lướt theo
      ["<C-u>"] = function() neoscroll.ctrl_u({ duration = 250 }) end,
      ["<C-d>"] = function() neoscroll.ctrl_d({ duration = 250 }) end,

      -- Ctrl + b / f (Cả trang): 450ms - chậm hơn chút vì quãng đường dài hơn
      ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 450 }) end,
      ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 450 }) end,

      -- Ctrl + y / e (Từng dòng): 100ms - cực nhanh
      ["<C-y>"] = function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 100 }) end,
      ["<C-e>"] = function() neoscroll.scroll(0.1, { move_cursor = false, duration = 100 }) end,

      -- zt, zz, zb (Căn chỉnh màn hình): 250ms
      ["zt"]    = function() neoscroll.zt({ half_win_duration = 250 }) end,
      ["zz"]    = function() neoscroll.zz({ half_win_duration = 250 }) end,
      ["zb"]    = function() neoscroll.zb({ half_win_duration = 250 }) end,
    }

    -- Áp dụng phím tắt cho các chế độ Normal, Visual, Select
    local modes = { 'n', 'v', 'x' }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
  end,
}
