return {
  "windwp/nvim-autopairs",
  event = "InsertEnter", -- chỉ load khi bắt đầu insert
  config = function()
    require("nvim-autopairs").setup({
      check_ts = true,  -- dùng Treesitter để biết ngữ cảnh
    })
  end,
}
