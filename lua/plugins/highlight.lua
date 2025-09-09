return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- treesitter không hỗ trợ lazy load, nên phải load thẳng
    lazy = false,
    opts = {
      -- parser cho các ngôn ngữ cần thiết
      ensure_installed = {
        "lua", "html", "css",
        "php", "blade", "php_only", "phpdoc",
        "dart",
      },
      sync_install = false,
      auto_install = true, -- tự động cài parser còn thiếu

      highlight = {
        enable = true, -- bật highlight
        additional_vim_regex_highlighting = false,
        disable = function(lang, buf) -- tránh lag file quá to
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  }
}
