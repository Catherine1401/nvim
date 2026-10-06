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

-- Chỉ mở giao diện giải quyết xung đột khi còn file chưa merge
local function open_conflicts()
	local unmerged = vim.fn.systemlist({ "git", "diff", "--name-only", "--diff-filter=U" })
	if vim.v.shell_error ~= 0 then
		vim.notify("Không phải git repo", vim.log.levels.WARN)
	elseif #unmerged == 0 then
		vim.notify("Không có xung đột để giải quyết", vim.log.levels.INFO)
	else
		-- Mở xong thì nhảy thẳng tới file xung đột đầu tiên thay vì file đầu danh sách
		vim.api.nvim_create_autocmd("User", {
			pattern = "DiffviewViewOpened",
			once = true,
			callback = function()
				-- Chờ diffview chọn xong file mặc định rồi mới đổi sang file xung đột
				vim.defer_fn(function()
					local view = require("diffview.lib").get_current_view()
					local first = view and view.files.conflicting[1]
					if first then
						view:set_file(first, true, true)
					end
				end, 300)
			end,
		})
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
			diff_buf_win_enter = function(bufnr, _, ctx)
				require("config.diff_lsp").on_buf_enter(bufnr, ctx)
			end,
			view_closed = function()
				require("config.diff_lsp").unlock_all()
			end,
		},
		-- Merge tool: ours và theirs chia đôi ở trên, file kết quả nằm riêng ở dưới
		view = { merge_tool = { layout = "diff3_mixed" } },
		keymaps = {
			view = { close_keymap, edit_keymap },
			file_panel = { close_keymap, edit_keymap },
			file_history_panel = { close_keymap, edit_keymap },
		},
	},
	keys = {
		{ "<leader>gv", open_diffview, desc = "Diff toàn bộ thay đổi" },
		{ "<leader>gx", open_conflicts, desc = "Giải quyết xung đột merge" },
		{ "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Lịch sử file hiện tại" },
		{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Đóng diffview" },
		{ "<leader>gz", toggle_full_diff, desc = "Bật/tắt hiện toàn bộ file trong diff" },
	},
}
