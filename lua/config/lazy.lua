-- lua/config/lazy.lua

-- 1. Bootstrap: Tự động tải lazy.nvim nếu chưa cài
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- 2. Setup Lazy.nvim
require("lazy").setup({
  spec = {
    -- QUAN TRỌNG: Dòng này bảo Lazy tự động tìm và nạp tất cả file trong folder lua/plugins
    { import = "plugins" },
  },

  -- Các cài đặt mặc định cho mọi plugin
  defaults = {
    -- Mặc định là Lazy-load (chỉ tải khi cần) để khởi động nhanh
    -- Trừ những plugin cậu set lazy = false thủ công
    lazy = false,
    version = false, -- Luôn dùng bản mới nhất (git master) thay vì tags
  },

  -- Tự động kiểm tra cập nhật plugin
  checker = {
    enabled = false,
    notify = true -- Tắt thông báo phiền phức, chỉ hiện icon nhỏ ở góc dưới
  },

  -- Tối ưu hiệu năng (Performance)
  performance = {
    rtp = {
      -- Tắt các plugin mặc định vô dụng của Vim để tiết kiệm RAM và khởi động nhanh
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin", -- Chúng ta đã dùng Neo-tree nên tắt cái này
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },

  -- Cấu hình giao diện cửa sổ quản lý Lazy (Gõ :Lazy để xem)
  ui = {
    border = "rounded", -- Viền bo tròn đồng bộ với hệ thống
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
