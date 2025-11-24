return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    dependencies = { 
      "rafamadriz/friendly-snippets",       -- Nguồn 1: Chuẩn VS Code (JSON)
      "molleweide/LuaSnip-snippets.nvim",   -- Nguồn 2: Nâng cao (Lua)
      "honza/vim-snippets",                 -- Nguồn 3: Cổ điển (SnipMate)
    },
    
    config = function()
      local ls = require("luasnip")

      ls.setup({
        history = true,
        update_events = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
      })

      -- === NẠP DỮ LIỆU TỪ CÁC NGUỒN ===

      -- 1. Nạp Friendly Snippets (VS Code style)
      -- Tự động nạp Flutter, Dart, JS, v.v...
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- 2. Nạp Snippets riêng của cậu (trong folder config/snippets)
      require("luasnip.loaders.from_vscode").lazy_load({ 
        paths = { vim.fn.stdpath("config") .. "/snippets" } 
      })

      -- 3. Nạp LuaSnip-snippets (Lua style)
      -- Nguồn này chứa các snippet thông minh (VD: gõ ngày tháng tự động...)
      require("luasnip.loaders.from_lua").lazy_load()

      -- 4. Nạp Vim-Snippets (SnipMate style)
      -- Nguồn cổ điển, bổ sung những gì 3 nguồn kia thiếu
      require("luasnip.loaders.from_snipmate").lazy_load()
    end,
  },
}
