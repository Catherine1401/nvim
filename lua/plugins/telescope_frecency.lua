return {
	{
		"nvim-telescope/telescope-frecency.nvim",
		version = "*",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("telescope").load_extension("frecency")
		end,
		keys = {
			{ "<leader><leader>", "<cmd>Telescope frecency workspace=CWD<cr>", desc = "Tìm file (gần nhất)" },
		},
	},
}
