return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("dashboard").setup({
        theme = "doom",
        hide = {
          statusline = true,
          tabline = true,
          winbar = true,
        },
        config = {
          -- 1. HEADER: Logo "HW" phong cách ANSI Shadow
          header = {
            "",
            " ██╗  ██╗██╗    ██╗",
            " ██║  ██║██║    ██║",
            " ███████║██║ █╗ ██║",
            " ██╔══██║██║███╗██║",
            " ██║  ██║╚███╔███╔╝",
            " ╚═╝  ╚═╝ ╚══╝╚══╝ ",
            "",
          },

          -- 2. CENTER: Các nút chức năng (Giữ nguyên cấu hình chuẩn lúc nãy)
          center = {
            {
              icon = " ",
              desc = "Find File           ",
              key = "f",
              action = "Telescope find_files",
            },
            {
              icon = " ",
              desc = "New File            ",
              key = "n",
              action = "ene | startinsert",
            },
            {
              icon = " ",
              desc = "Recent Files        ",
              key = "r",
              action = "Telescope oldfiles",
            },
            {
              icon = " ",
              desc = "Find Text           ",
              key = "g",
              action = "Telescope live_grep",
            },
            {
              icon = " ",
              desc = "Projects            ",
              key = "p",
              action = "Telescope projects",
            },
            {
              icon = " ",
              desc = "Configuration       ",
              key = "c",
              -- Lệnh mở ngay folder config của cậu
              action = "lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })",
            },
            {
              icon = " ",
              desc = "Quit                ",
              key = "q",
              action = "qa",
            },
          },

          -- 3. FOOTER
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      })
    end,
  },
}
