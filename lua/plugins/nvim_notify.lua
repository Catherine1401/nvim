return {
	"rcarriga/nvim-notify",
	opts = {
		timeout = 3000,

		render = "default",

		stages = "fade_in_slide_out",

		background_colour = "#000000",

		max_height = function()
			return math.floor(vim.o.lines * 0.75)
		end,
		max_width = function()
			return math.floor(vim.o.columns * 0.75)
		end,

		on_open = function(win)
			vim.api.nvim_win_set_option(win, "winblend", 10)
		end,
	},

	config = function(_, opts)
		require("notify").setup(opts)

		vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = "#db4b4b" })
		vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = "#e0af68" })
		vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = "#0db9d7" })
		vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = "#9ece6a" })
		vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = "#d0d0d0" })

		vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = "#db4b4b" })
		vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = "#e0af68" })
		vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = "#0db9d7" })
		vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", { fg = "#9ece6a" })
		vim.api.nvim_set_hl(0, "NotifyTRACEIcon", { fg = "#d0d0d0" })

		vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = "#db4b4b" })
		vim.api.nvim_set_hl(0, "NotifyWARNTitle", { fg = "#e0af68" })
		vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = "#0db9d7" })
		vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { fg = "#9ece6a" })
		vim.api.nvim_set_hl(0, "NotifyTRACETitle", { fg = "#d0d0d0" })
	end,
	keys = {
		{
			"<leader>un",
			function()
				require("telescope").extensions.notify.notify()
			end,
			desc = "Notify History (Telescope)",
		},
	},
}
