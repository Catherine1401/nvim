local autocmd = vim.api.nvim_create_autocmd

-- highlight yanked text
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 200
    })
  end,
})

-- global biến lưu phím
vim.g.last_keys = ""

-- hook tất cả phím
vim.on_key(function(key)
  vim.g.last_keys = key
end, nil)


-- Bật hiển thị diagnostics
vim.diagnostic.config({
  virtual_text = true,  -- hiển thị text lỗi ngay trong code
  signs = true,         -- ký hiệu ở cột trái (sign column)
  underline = true,     -- gạch chân chỗ lỗi
  update_in_insert = false, -- không update khi đang insert
  severity_sort = true, -- sắp xếp lỗi theo mức độ
})
