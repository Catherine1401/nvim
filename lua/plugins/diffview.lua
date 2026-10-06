-- Bật/tắt gấp phần không đổi ở mọi cửa sổ diff của tab hiện tại
local function toggle_full_diff()
	local wins = vim.tbl_filter(function(win)
		return vim.wo[win].diff
	end, vim.api.nvim_tabpage_list_wins(0))
	if #wins == 0 then
		return
	end
	local enable = not vim.wo[wins[1]].foldenable
	for _, win in ipairs(wins) do
		vim.wo[win].foldenable = enable
	end
	-- Đồng bộ lại vị trí cuộn giữa các bên sau khi đổi fold
	vim.api.nvim_win_call(wins[1], function()
		vim.cmd("syncbind")
	end)
end

-- Chỉ mở diffview khi có thay đổi, tránh kẹt trong giao diện rỗng
local function open_diffview()
	local status = vim.fn.systemlist({ "git", "status", "--porcelain" })
	if vim.v.shell_error ~= 0 then
		vim.notify("Không phải git repo", vim.log.levels.WARN)
	elseif #status == 0 then
		vim.notify("Không có thay đổi để diff", vim.log.levels.INFO)
	else
		vim.cmd("DiffviewOpen")
	end
end

-- Phím q đóng diffview ở mọi cửa sổ của nó
local close_keymap = { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Đóng diffview" } }

-- Diffview chỉ đọc; gf mở khoá file thật rồi nhảy tới dòng đang đứng để sửa
local edit_keymap = { "n", "gf", function() require("config.diff_lsp").goto_edit() end, { desc = "Mở file thật để sửa" } }

return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
	config = function(_, opts)
		require("diffview").setup(opts)
		require("config.diff_lsp").setup()
	end,
	opts = {
		hooks = {
			diff_buf_win_enter = function(bufnr)
				require("config.diff_lsp").on_buf_enter(bufnr)
			end,
			view_closed = function()
				require("config.diff_lsp").unlock_all()
			end,
		},
		keymaps = {
			view = { close_keymap, edit_keymap },
			file_panel = { close_keymap, edit_keymap },
			file_history_panel = { close_keymap, edit_keymap },
		},
	},
	keys = {
		{ "<leader>gv", open_diffview, desc = "Diff toàn bộ thay đổi" },
		{ "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Lịch sử file hiện tại" },
		{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Đóng diffview" },
		{ "<leader>gz", toggle_full_diff, desc = "Bật/tắt hiện toàn bộ file trong diff" },
	},
}
