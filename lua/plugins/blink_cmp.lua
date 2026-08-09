-- autocomplete

return {
	"saghen/blink.cmp",
	build = function()
		require("blink.cmp").build():pwait()
	end,
	dependencies = { "L3MON4D3/LuaSnip", "saghen/blink.lib" },
	opts = {
		snippets = {
			preset = "luasnip",
		},
		completion = {
			keyword = { range = "full" },
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
		signature = { enabled = true },
		keymap = {
			preset = "enter",
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<C-l>"] = { "snippet_forward", "fallback" },
			["<C-h>"] = { "snippet_backward", "fallback" },
		},
	},
}
