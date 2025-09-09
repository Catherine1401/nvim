return {
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" }, -- lazy load an toàn
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,         -- tự động đóng tag
          enable_rename = true,        -- đổi tên cặp tag khi sửa
          enable_close_on_slash = false, -- gõ </ thì mới đóng
        },
        -- nếu muốn tùy chỉnh riêng từng filetype
        per_filetype = {
          -- ví dụ tắt autoclose cho html
          -- html = { enable_close = false },
        },
        -- thêm alias nếu parser nào đó giống html
        aliases = {
          -- ["blade"] = "html",
        },
      })
    end,
  },
}
