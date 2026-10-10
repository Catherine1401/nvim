-- Diffview: chọn tab và cửa sổ để gf mở file thật, không ghi đè tab log/scratch (nofile)
local M = {}

-- Cửa sổ thường (không float) đang giữ file thật hoặc buffer trống; ưu tiên cửa sổ hiện tại của tab
local function file_win(tab)
	local current = vim.api.nvim_tabpage_get_win(tab)
	local wins = vim.api.nvim_tabpage_list_wins(tab)
	table.sort(wins, function(a, b)
		return a == current and b ~= current
	end)
	for _, win in ipairs(wins) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.api.nvim_win_get_config(win).relative == "" and vim.bo[buf].buftype == "" then
			return win
		end
	end
end

-- Tab không thuộc diffview nào, ưu tiên tab trước đó mà diffview sẽ chọn
local function candidate_tabs(lib)
	local is_view = {}
	for _, view in ipairs(lib.views) do
		is_view[view.tabpage] = true
	end
	local tabs = {}
	local prev = lib.get_prev_non_view_tabpage()
	if prev then
		tabs[1] = prev
	end
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		if tab ~= prev and not is_view[tab] then
			tabs[#tabs + 1] = tab
		end
	end
	return tabs
end

-- Chạy trước goto_file_edit: tab trước đó không có cửa sổ file thì dùng tab file khác hoặc tạo tab mới,
-- rồi ghé qua tab đó và quay lại để nó thành tab trước đó mà diffview chọn
function M.prepare()
	local lib = require("diffview.lib")
	local view_tab = vim.api.nvim_get_current_tabpage()
	local tabs = candidate_tabs(lib)
	if #tabs == 0 then
		return
	end
	local target, win
	for _, tab in ipairs(tabs) do
		win = file_win(tab)
		if win then
			target = tab
			break
		end
	end
	if win then
		vim.api.nvim_tabpage_set_win(target, win)
		vim.api.nvim_set_current_tabpage(target)
	else
		vim.cmd("tabnew")
	end
	vim.api.nvim_set_current_tabpage(view_tab)
end

return M
