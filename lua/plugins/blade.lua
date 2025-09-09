return {
  {
   "ricardoramirezr/blade-nav.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp",       -- nếu dùng cmp
    },
    ft = { "blade", "php" },
    opts = {
      close_tag_on_complete = true, -- tự đóng </ khi autocomplete component
    },
  }
}
