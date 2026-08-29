return {
	"kylechui/nvim-surround",
	version = "^4.0.0",
	event = "VeryLazy",
	init = function()
		-- Tắt default visual mapping (S và gS) trước khi plugin load
		vim.g.nvim_surround_no_visual_mappings = true
	end,
	config = function()
		require("nvim-surround").setup({})

		-- Map lại bằng <Plug> mappings
		vim.keymap.set("x", "Z", "<Plug>(nvim-surround-visual)", { desc = "Surround visual" })
		vim.keymap.set("x", "gZ", "<Plug>(nvim-surround-visual-line)", { desc = "Surround visual line" })
	end,
}
