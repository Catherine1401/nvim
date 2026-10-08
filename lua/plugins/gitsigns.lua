return {
	"lewis6991/gitsigns.nvim",

	config = function()
		local gs = require("gitsigns")

		gs.setup({
			current_line_blame = true,
			preview_config = { border = "double", style = "minimal", relative = "cursor", row = 0, col = 1 },
		})

		require("config.diff_blame").setup()

		-- Buffer của diffview (bản cũ trong commit) không có hunk gitsigns đúng nghĩa nên dùng ]c / [c của chế độ diff
		local function jump_hunk(gs_jump, diff_key)
			return function()
				if vim.wo.diff and (vim.b.diff_origin or not vim.b.gitsigns_status_dict) then
					pcall(vim.cmd, "normal! " .. diff_key)
				else
					gs_jump()
				end
			end
		end

		-- Navigation
		vim.keymap.set("n", "<leader>ga", gs.stage_hunk, { desc = "Stage hunk" })
		vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
		vim.keymap.set("n", "<leader>gn", jump_hunk(gs.next_hunk, "]c"), { desc = "Next hunk" })
		vim.keymap.set("n", "<leader>gp", jump_hunk(gs.prev_hunk, "[c"), { desc = "Previous hunk" })
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
