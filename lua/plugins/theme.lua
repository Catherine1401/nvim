return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			vim.cmd("colorscheme tokyonight")
		end,
	},
	-- {
	-- 	"navarasu/onedark.nvim",
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	config = function()
	-- 		require("onedark").setup({
	-- 			style = "deep",
	-- 		})
	-- 		require("onedark").load()
	-- 	end,
	-- },

	--  {
	-- 	priority = 1000, -- Ensure it loads first
	-- 	config = function()
	-- 		vim.cmd("colorscheme vaporwave")
	-- 	end,
	-- },
	-- {
	-- 	"Mofiqul/dracula.nvim",
	-- 	priority = 1000, -- Ensure it loads first
	-- 	opts = {
	-- 		colorscheme = "dracula",
	-- 	},
	-- },
}
