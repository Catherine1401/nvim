return {
	"lewis6991/gitsigns.nvim",

	config = function()
		local gs = require("gitsigns")

		gs.setup({
			current_line_blame = true,
		})

		require("config.diff_blame").setup()

		-- Navigation
		vim.keymap.set("n", "<leader>ga", gs.stage_hunk, { desc = "Stage hunk" })
		vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
		vim.keymap.set("n", "<leader>gn", gs.next_hunk, { desc = "Next hunk" })
		vim.keymap.set("n", "<leader>gp", gs.prev_hunk, { desc = "Previous hunk" })
		vim.keymap.set("n", "<leader>gd", gs.diffthis, { desc = "Diff" })
		-- Blame đầy đủ dạng float, đọc được cả khi cửa sổ hẹp như diffview
		vim.keymap.set("n", "<leader>gb", function()
			if vim.b.diff_origin then
				require("config.diff_blame").show()
			else
				gs.blame_line({ full = true })
			end
		end, { desc = "Blame dòng hiện tại" })
	end,
}
