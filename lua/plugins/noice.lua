return {
  -- lazy.nvim
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
    config = function()

-- Noice.nvim configuration for custom notifications
require("noice").setup({
  -- Cấu hình cmdline
  cmdline = {
    enabled = true,
    view = "cmdline_popup", -- popup style cmdline
    opts = {},
    format = {
      cmdline = { pattern = "^:", icon = "", lang = "vim" },
      search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
      search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
      filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
      lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
      help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
      input = { view = "cmdline_input", icon = "󰥻 " },
    },
  },

  -- Cấu hình messages để có notification như trong ảnh
  messages = {
    enabled = true,
    view = "notify", -- sử dụng notify view
    view_error = "notify", -- errors hiển thị trong notify
    view_warn = "notify", -- warnings hiển thị trong notify
    view_history = "messages",
    view_search = "virtualtext",
  },

  -- Cấu hình notify view
  notify = {
    enabled = true,
    view = "notify",
  },

  -- Cấu hình LSP
  lsp = {
    -- override markdown rendering cho cmp và plugins khác
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    progress = {
      enabled = true,
      format = "lsp_progress",
      format_done = "lsp_progress_done",
      throttle = 1000 / 30,
      view = "mini",
    },
    hover = {
      enabled = true,
      silent = false,
    },
    signature = {
      enabled = true,
      auto_open = {
        enabled = true,
        trigger = true,
        luasnip = true,
        throttle = 50,
      },
    },
    message = {
      enabled = true,
      view = "notify",
      opts = {},
    },
  },

  -- Cấu hình views tùy chỉnh
  views = {
    notify = {
      backend = "notify",
      fallback = "mini",
      format = "notify",
      replace = false,
      merge = false,
      level = nil,
    },
    cmdline_popup = {
      position = {
        row = 5,
        col = "50%",
      },
      size = {
        width = 60,
        height = "auto",
      },
    },
    popupmenu = {
      relative = "editor",
      position = {
        row = 8,
        col = "50%",
      },
      size = {
        width = 60,
        height = 10,
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
      win_options = {
        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
      },
    },
  },

  -- Cấu hình routes để điều hướng messages
  routes = {
    -- Route cho error messages
    {
      filter = {
        event = "msg_show",
        error = true,
      },
      view = "notify",
      opts = { 
        replace = false, 
        merge = false,
        level = "error",
        title = "Error",
      },
    },
    -- Route cho warning messages
    {
      filter = {
        event = "msg_show",
        warning = true,
      },
      view = "notify",
      opts = { 
        replace = false, 
        merge = false,
        level = "warn",
        title = "Warning",
      },
    },
    -- Route cho info messages
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      view = "notify",
      opts = { 
        replace = false, 
        merge = false,
        level = "info",
        title = "Info",
      },
    },
    -- Route messages dài sang split
    {
      filter = {
        event = "msg_show",
        min_height = 5,
      },
      view = "split",
    },
  },

  -- Presets để dễ cấu hình
  presets = {
    bottom_search = true, -- cmdline cổ điển cho search
    command_palette = true, -- cmdline và popupmenu cùng nhau
    long_message_to_split = true, -- messages dài sẽ hiển thị trong split
    inc_rename = false,
    lsp_doc_border = false,
  },

  -- Cấu hình format
  format = {
    -- Format cho notify view
    notify = {
      { "{title} ", hl_group = "NoiceFormatTitle" },
      { "{message}" },
    },
    -- Format tùy chỉnh với icon và màu sắc
    custom_notify = {
      { "{level} ", hl_group = "NoiceFormatLevel" },
      { "{title} ", hl_group = "NoiceFormatTitle" },
      { "{message}" },
      { " ", "{date}", hl_group = "NoiceFormatDate" },
    },
  },

  -- Cấu hình throttle
  throttle = 1000 / 30,
})
    end,
  },
}
