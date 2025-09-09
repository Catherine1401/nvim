return {
  "uga-rosa/ccc.nvim",
  config = function()
    require("ccc").setup({
      highlighter = {
        auto_enable = true,   -- bật highlight màu tự động
        lsp = true,           -- highlight màu trả về từ LSP
      },
      pickers = {
        -- bật bảng chọn màu HSV (trực quan hơn RGB)
        ccc_hsv = true,
      },
      convert = {
        -- copy màu dưới dạng hex khi yank
        hex = true,
      },
    })
  end,
}
