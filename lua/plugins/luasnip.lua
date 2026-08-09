-- snippets
return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"molleweide/LuaSnip-snippets.nvim",
		"honza/vim-snippets",
	},
	config = function()
		local ls = require("luasnip")

		ls.setup({
			history = true,
			update_events = "TextChanged,TextChangedI",
			delete_check_events = "TextChanged",
		})

		-- Nguồn 1, Friendly Snippets, chuẩn VS Code, tự động có Flutter, Dart, JS
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Nguồn 2, snippet riêng của bạn
		require("luasnip.loaders.from_vscode").lazy_load({
			paths = { vim.fn.stdpath("config") .. "/snippets/custom/" },
		})

		-- Nguồn 3, LuaSnip-snippets, kiểu Lua, có snippet thông minh như ngày tháng
		require("luasnip.loaders.from_lua").lazy_load()

		-- Nguồn 4, vim-snippets, kiểu SnipMate cổ điển
		require("luasnip.loaders.from_snipmate").lazy_load()
	end,
}
