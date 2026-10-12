-- Nhảy hunk trong chế độ diff có vòng lại: ]c / [c của Vim dừng ở hunk cuối / đầu
local M = {}

-- Dòng thuộc vùng khác biệt của diff
local function in_change(lnum)
	return vim.fn.diff_hlID(lnum, 1) ~= 0
end

-- Về hunk đầu tiên của buffer, hunk nằm ngay dòng 1 thì ]c sẽ bỏ qua nên đứng yên
local function wrap_to_first()
	vim.cmd("normal! gg")
	if not in_change(1) then
		pcall(vim.cmd, "normal! ]c")
	end
end

-- Về đầu hunk cuối của buffer, hunk chạm dòng cuối thì lùi lên dòng đầu hunk
local function wrap_to_last()
	local last = vim.fn.line("$")
	vim.cmd("normal! G")
	if not in_change(last) then
		pcall(vim.cmd, "normal! [c")
		return
	end
	local start = last
	while start > 1 and in_change(start - 1) do
		start = start - 1
	end
	vim.api.nvim_win_set_cursor(0, { start, 0 })
end

-- Buffer không có hunk nào thì con trỏ phải đứng nguyên chỗ cũ
function M.jump(forward)
	local before = vim.api.nvim_win_get_cursor(0)
	pcall(vim.cmd, "normal! " .. (forward and "]c" or "[c"))
	if before[1] ~= vim.api.nvim_win_get_cursor(0)[1] then
		return
	end
	local edge = forward and 1 or vim.fn.line("$")
	if forward then
		wrap_to_first()
	else
		wrap_to_last()
	end
	if vim.fn.line(".") == edge and not in_change(edge) then
		vim.api.nvim_win_set_cursor(0, before)
	end
end

return M
