return {

	{
		"saghen/blink.cmp",
		build = "cargo build --release",
		dependencies = { "L3MON4D3/LuaSnip" },

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
	},

	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp", -- Docs khuyên nên có cái này để chạy tốt các biến
		config = function()
			local ls = require("luasnip")

			-- Nạp snippets theo đúng chỉ dẫn của VSCode Loader
			require("luasnip.loaders.from_vscode").lazy_load({
				-- Cách viết này đảm bảo LuaSnip tìm đúng thư mục chứa package.json
				paths = { vim.fn.stdpath("config") .. "/snippets/custom/" },
			})

			-- Cho phép quay lại snippet cũ nếu cậu lỡ nhảy quá tay (history)
			ls.config.set_config({
				history = true,
				update_events = "TextChanged,TextChangedI",
			})
		end,
	},
}

