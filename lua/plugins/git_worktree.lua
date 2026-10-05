return {
	"polarmutex/git-worktree.nvim",
	version = "^2",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	keys = {
		{
			"<leader>gw",
			function()
				require("telescope").extensions.git_worktree.git_worktree()
			end,
			desc = "Chuyển/xoá worktree",
		},
		{
			"<leader>gW",
			function()
				-- Không dùng picker tạo của extension vì nó giả định repo bare và cd vào .git
				vim.ui.input({ prompt = "Branch mới: " }, function(branch)
					if not branch or branch == "" then
						return
					end
					vim.ui.input({ prompt = "Đường dẫn worktree: ", default = "../" .. branch }, function(path)
						if path and path ~= "" then
							require("git-worktree").create_worktree(path, branch, nil)
						end
					end)
				end)
			end,
			desc = "Tạo worktree",
		},
	},
	config = function()
		require("telescope").load_extension("git_worktree")
		local Hooks = require("git-worktree.hooks")
		-- Đổi cwd và buffer hiện tại sang worktree mới khi switch
		Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)
	end,
}
