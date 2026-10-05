-- highlight current scope
return {
	"echasnovski/mini.indentscope",
	version = false,
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		symbol = "│",
		options = { try_as_border = true },
		draw = {
			delay = 100,
			priority = 2,
			animation = function(s, n)
				return s / n * 20
			end,
		},
		mappings = {
			object_scope = "",
			object_scope_with_border = "",
			goto_top = "",
			goto_bottom = "",
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})
	end,
}
