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

return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
	keys = {
		{ "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Diff toàn bộ thay đổi" },
		{ "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Lịch sử file hiện tại" },
		{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Đóng diffview" },
		{ "<leader>gz", toggle_full_diff, desc = "Bật/tắt hiện toàn bộ file trong diff" },
	},
}
