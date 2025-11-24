return {
  'saghen/blink.cmp',
  dependencies = { "L3MON4D3/LuaSnip" },
  build = 'cargo build --release',
  opts = {
    snippets = {
      preset = 'luasnip',
    },
    completion = {
      keyword = {
        range = 'full',
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
      },
    },
    signature = {
      enabled = true,
    },
    keymap = {
      preset = 'enter',
      ['<Tab>'] = {'select_next', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = {'select_prev', 'snippet_backward', 'fallback' },
    },
  },
}
