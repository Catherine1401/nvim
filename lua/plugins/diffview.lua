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

-- Diffview so sánh working tree (không có rev) đang mở thì quay lại tab đó và nạp lại, không mở thêm tab; view của commit không tính
local function focus_open_diffview()
	local lib = package.loaded["diffview.lib"]
	if not lib then
		return false
	end
	local diff_view = require("diffview.scene.views.diff.diff_view").DiffView
	for _, view in ipairs(lib.views) do
		if view:instanceof(diff_view) and view.rev_arg == nil and vim.api.nvim_tabpage_is_valid(view.tabpage) then
			vim.api.nvim_set_current_tabpage(view.tabpage)
			vim.cmd("DiffviewRefresh")
			return true
		end
	end
	return false
end

-- Chỉ mở diffview khi có thay đổi, tránh kẹt trong giao diện rỗng
local function open_diffview()
	local status = vim.fn.systemlist({ "git", "status", "--porcelain" })
	if vim.v.shell_error ~= 0 then
		vim.notify("Không phải git repo", vim.log.levels.WARN)
	elseif #status == 0 then
		vim.notify("Không có thay đổi để diff", vim.log.levels.INFO)
	elseif not focus_open_diffview() then
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

-- Chọn ours/theirs/base/cả ba/xoá cho khối xung đột, có báo khi con trỏ chưa ở trong khối
local function choose_keymaps()
	local keys = { co = "ours", ct = "theirs", cb = "base", ca = "all", dx = "none" }
	local maps = {}
	for key, target in pairs(keys) do
		local lhs = key:sub(1, 1) == "c" and "<leader>" .. key or key
		maps[#maps + 1] = { "n", lhs, function() require("config.diff_conflict").choose(target)() end, { desc = "Chọn " .. target .. " cho khối xung đột" } }
	end
	return maps
end

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
			-- Chạy ngay trước :tabclose của diffview: buffer đã sửa không được phép ẩn sẽ làm :tabclose báo E445
			view_leave = function(view)
				if view.tabpage and vim.api.nvim_tabpage_is_valid(view.tabpage) then
					require("config.diff_close").release(view.tabpage)
				end
			end,
			view_closed = function()
				require("config.diff_lsp").unlock_all()
				require("config.diff_return").clear()
			end,
		},
		-- Merge tool: ours và theirs chia đôi ở trên, file kết quả nằm riêng ở dưới
		view = { merge_tool = { layout = "diff3_mixed" } },
		keymaps = {
			view = vim.list_extend({ close_keymap, edit_keymap }, choose_keymaps()),
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
