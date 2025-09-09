-- 3. nvim-cmp setup
-- ==============================
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load() -- load friendly-snippets

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
    { name = "blade-nav" },
  },
})

-- ==============================
-- 4. LSP setup
-- ==============================
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Lua
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})

-- HTML
lspconfig.html.setup({ capabilities = capabilities })

-- CSS
lspconfig.cssls.setup({ capabilities = capabilities })

-- Emmet
lspconfig.emmet_ls.setup({
  capabilities = capabilities,
  filetypes = { "html", "css", "javascriptreact", "typescriptreact" },
})

-- php
lspconfig.intelephense.setup({
  capabilities = capabilities,
})

lspconfig.phpactor.setup({
  capabilities = capabilities,
})

-- dart
require("lspconfig").dartls.setup({
  capabilities = capabilities,
  cmd = { "dart", "language-server", "--protocol=lsp" },
  filetypes = { "dart" },
  init_options = {
    onlyAnalyzeProjectsWithOpenFiles = true,
    suggestFromUnimportedLibraries = true,
    closingLabels = true,
  },
})

-- python
lspconfig.pyright.setup({
  capabilities = capabilities,
})
