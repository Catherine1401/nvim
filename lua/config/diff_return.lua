-- Diffview: sau gf, Ctrl-o đi hết jumplist của file đang sửa rồi quay về đúng cửa sổ và vị trí diffview đã bấm gf
local M = {}

local origins = {} -- buffer giữ chỗ -> { tab, win, pos, edit_win, edit_buf } của đúng lần gf tạo ra nó
local current -- nơi bấm gf, chờ mark_arrival bổ sung điểm đến
local arming = false -- đang dựng jumplist nên chưa coi việc vào buffer giữ chỗ là Ctrl-o

local HOLDER_PREFIX = "diffview-return-"

-- Vị trí con trỏ trong file thật ngay trước Ctrl-o: Vim ghi nó vào mục cuối của jumplist
local function last_edit_pos(origin)
	local list = vim.fn.getjumplist(origin.edit_win)[1]
	for i = #list, 1, -1 do
		if list[i].bufnr == origin.edit_buf then
			return { list[i].lnum, list[i].col }
		end
	end
	return { 1, 0 }
end

local function restore_edit_window(origin)
	local pos = last_edit_pos(origin)
	vim.api.nvim_win_call(origin.edit_win, function()
		vim.cmd("keepjumps buffer " .. origin.edit_buf)
		pcall(vim.api.nvim_win_set_cursor, origin.edit_win, pos)
	end)
end

local function focus_origin(origin)
	if vim.api.nvim_tabpage_is_valid(origin.tab) and vim.api.nvim_win_is_valid(origin.win) then
		vim.api.nvim_set_current_tabpage(origin.tab)
		vim.api.nvim_set_current_win(origin.win)
		pcall(vim.api.nvim_win_set_cursor, origin.win, origin.pos)
	end
end

-- Cửa sổ vừa nhảy vào buffer giữ chỗ: cửa sổ sửa thì quay về diffview, cửa sổ khác thì trả lại buffer cũ
local function on_holder_enter(holder)
	local origin, win = origins[holder], vim.api.nvim_get_current_win()
	if vim.api.nvim_get_current_buf() ~= holder then
		return
	end
	if origin and win == origin.edit_win and vim.api.nvim_buf_is_valid(origin.edit_buf) then
		restore_edit_window(origin)
		focus_origin(origin)
	else
		pcall(vim.cmd, "keepjumps buffer #")
	end
end

local function new_holder(origin)
	local holder = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(holder, HOLDER_PREFIX .. holder)
	vim.bo[holder].bufhidden = "hide"
	origins[holder] = origin
	vim.api.nvim_create_autocmd("BufEnter", {
		buffer = holder,
		callback = function()
			-- :buffer tự bật buflisted, tắt lại để bufferline và picker không thấy buffer giữ chỗ
			vim.bo[holder].buflisted = false
			if not arming then
				vim.schedule(function()
					on_holder_enter(holder)
				end)
			end
		end,
	})
	return holder
end

-- Bỏ buffer giữ chỗ của diffview đã đóng để jumplist không còn mục thừa
local function prune()
	for holder, origin in pairs(origins) do
		if not vim.api.nvim_tabpage_is_valid(origin.tab) then
			origins[holder] = nil
			pcall(vim.api.nvim_buf_delete, holder, { force = true })
		end
	end
end

-- Ghi lại nơi bấm gf; gọi trước khi mở file thật
function M.mark_origin()
	current = { tab = vim.api.nvim_get_current_tabpage(), win = vim.api.nvim_get_current_win(), pos = vim.api.nvim_win_get_cursor(0) }
end

-- Sau khi mở file thật: chèn buffer giữ chỗ vào jumplist ngay trước điểm đến
function M.mark_arrival()
	local origin = current
	current = nil
	if not origin or vim.api.nvim_get_current_tabpage() == origin.tab then
		return
	end
	local win, buf, pos = vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf(), vim.api.nvim_win_get_cursor(0)
	origin.edit_win, origin.edit_buf = win, buf
	prune()
	arming = true
	vim.cmd("buffer " .. new_holder(origin))
	vim.cmd("buffer " .. buf)
	vim.api.nvim_win_set_cursor(win, pos)
	arming = false
end

-- Chặn buffer giữ chỗ rò ra ngoài phiên: thoát nvim thì xoá hết, mục jumplist cũ trong shada trỏ vào tên đó thì dọn
function M.setup()
	local group = vim.api.nvim_create_augroup("DiffReturn", {})
	vim.api.nvim_create_autocmd("VimLeavePre", { group = group, callback = M.clear })
	vim.api.nvim_create_autocmd("BufEnter", {
		group = group,
		pattern = "*" .. HOLDER_PREFIX .. "*",
		callback = function(ev)
			if origins[ev.buf] then
				return
			end
			vim.schedule(function()
				pcall(vim.cmd, "keepjumps buffer #")
				pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
			end)
		end,
	})
end

-- Cửa sổ diffview tách ra từ cửa sổ khác nên thừa hưởng jumplist của nó; xoá để Ctrl-o không kéo cửa sổ diff sang buffer lạ (log, diffview://null)
function M.clear_jumps(win)
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_call(win, function()
			vim.cmd("clearjumps")
		end)
	end
end

-- Diffview đóng: bỏ mọi buffer giữ chỗ
function M.clear()
	current = nil
	for holder in pairs(origins) do
		pcall(vim.api.nvim_buf_delete, holder, { force = true })
	end
	origins = {}
end

return M
