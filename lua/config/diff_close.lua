-- Đóng tab diffview không bị E445/E37: buffer đã sửa mà nvim không được phép ẩn sẽ chặn :tabclose đóng cửa sổ chứa nó
local M = {}

-- Buffer được phép ẩn khi bufhidden=hide, hoặc để trống và option 'hidden' đang bật
local function can_hide(buf)
	local bufhidden = vim.bo[buf].bufhidden
	return bufhidden == "hide" or (bufhidden == "" and vim.o.hidden)
end

-- Đặt bufhidden=hide cho buffer đã sửa mà không được phép ẩn (mọi cửa sổ trong tab) để đóng cửa sổ chỉ ẩn buffer,
-- giữ nguyên thay đổi; trả về tên các buffer đã đổi
function M.release(tabpage)
	local released = {}
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].modified and not can_hide(buf) then
			vim.bo[buf].bufhidden = "hide"
			released[#released + 1] = vim.api.nvim_buf_get_name(buf)
		end
	end
	return released
end

return M
