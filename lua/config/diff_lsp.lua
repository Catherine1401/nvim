-- Diffview: buffer diffview:// mượn tên file anh em trong project để LSP thật gắn vào, và mọi buffer diff chỉ đọc
local M = {}

local shadows = {} -- buffer diffview:// đã đổi tên -> true
local locked = {} -- buffer file thật đã khoá -> { modifiable, readonly }

-- Tên buffer diffview://<git dir>/<rev>/<path>: rev là :N: (index) hoặc hash 11 ký tự
local REV_PATTERNS = { ":%d:", string.rep("%x", 11) }

-- Đường dẫn file thật (toplevel của worktree hiện tại + path trong tên) và rev
local function parse_name(name)
	local view = require("diffview.lib").get_current_view()
	local toplevel = view and view.adapter.ctx.toplevel
	if not toplevel then
		return nil
	end
	for _, rev_pattern in ipairs(REV_PATTERNS) do
		local rev, path = name:match("^diffview://.-/(" .. rev_pattern .. ")/(.+)$")
		if rev then
			return toplevel .. "/" .. path, rev
		end
	end
end

-- Tên giả cùng thư mục, khác file thật: <stem>.<rev>.<bufnr>.<ext>
local function shadow_name(path, rev, buf)
	local dir, base = vim.fs.dirname(path), vim.fs.basename(path)
	local stem, ext = base:match("^(.*)(%.[^.]*)$")
	return string.format("%s/%s.%s.%d%s", dir, stem or base, (rev:gsub("%W", "_")), buf, ext or "")
end

-- Client đang chạy cho cùng filetype và root bao phủ file thì gắn vào buffer
local function attach_clients(buf)
	local path, ft = vim.api.nvim_buf_get_name(buf), vim.bo[buf].filetype
	for _, client in ipairs(vim.lsp.get_clients()) do
		local root = client.root_dir
		if root and vim.startswith(path, root .. "/") and #vim.lsp.get_clients({ bufnr = buf, id = client.id }) == 0 then
			for other in pairs(client.attached_buffers) do
				if not shadows[other] and vim.api.nvim_buf_is_valid(other) and vim.bo[other].filetype == ft then
					vim.lsp.buf_attach_client(buf, client.id)
					break
				end
			end
		end
	end
end

local function prepare_shadow(buf)
	local path, rev = parse_name(vim.api.nvim_buf_get_name(buf))
	if not path then
		return
	end
	shadows[buf] = true
	vim.b[buf].diff_origin = { path = path, rev = rev }
	vim.api.nvim_buf_set_name(buf, shadow_name(path, rev, buf))
	-- nowrite để nvim không coi buffer đã đổi tên là có thay đổi cần ghi (tránh E445 khi đóng)
	vim.bo[buf].buftype = "nowrite"
	attach_clients(buf)
end

-- Khoá buffer: file thật nhớ lại trạng thái cũ để mở khoá khi cần sửa
local function lock(buf)
	if not shadows[buf] and not locked[buf] and vim.bo[buf].buftype == "" then
		locked[buf] = { modifiable = vim.bo[buf].modifiable, readonly = vim.bo[buf].readonly }
	end
	vim.bo[buf].modifiable = false
	vim.bo[buf].readonly = true
end

-- Phím LSP là buffer-local nên diffview xoá mất khi rời đi; chạy lại đúng nhóm autocmd đặt phím LSP
local function restore_lsp_keymaps(buf)
	if #vim.lsp.get_clients({ bufnr = buf }) > 0 then
		pcall(vim.api.nvim_exec_autocmds, "LspAttach", { group = "UserLspConfig", buffer = buf })
	end
end

-- Buffer file thật dùng chung với tab sửa: chỉ khoá khi đứng ở tab diffview, tab khác trả trạng thái cũ
local function sync_lock()
	local in_view = require("diffview.lib").get_current_view() ~= nil
	for buf, state in pairs(locked) do
		if vim.api.nvim_buf_is_valid(buf) then
			vim.bo[buf].modifiable = not in_view and state.modifiable
			vim.bo[buf].readonly = in_view or state.readonly
			if not in_view then
				restore_lsp_keymaps(buf)
			end
		end
	end
end

local function unlock_all()
	for buf, state in pairs(locked) do
		if vim.api.nvim_buf_is_valid(buf) then
			vim.bo[buf].modifiable = state.modifiable
			vim.bo[buf].readonly = state.readonly
		end
	end
	locked = {}
end

-- Cột kết quả (ký hiệu b) của merge tool ba/bốn cột phải sửa được để chọn ours/theirs
local function is_merge_result(ctx)
	return ctx ~= nil and ctx.symbol == "b" and ctx.layout_name:find("^diff[34]") ~= nil
end

-- Hook diffview: buffer vào cửa sổ diff
function M.on_buf_enter(buf, ctx)
	if vim.api.nvim_buf_get_name(buf):find("^diffview://") then
		prepare_shadow(buf)
	end
	if not is_merge_result(ctx) then
		lock(buf)
	end
end

-- Mở file thật để sửa tại dòng đang đứng; Ctrl-o ở đó quay lại đúng chỗ này
function M.goto_edit()
	local back = require("config.diff_return")
	back.mark_origin()
	require("diffview.actions").goto_file_edit()
	sync_lock()
	back.mark_arrival()
end

function M.setup()
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function()
			for buf in pairs(shadows) do
				if vim.api.nvim_buf_is_valid(buf) then
					attach_clients(buf)
				end
			end
		end,
	})
	vim.api.nvim_create_autocmd("TabEnter", { callback = sync_lock })
	vim.api.nvim_create_autocmd("BufWipeout", {
		callback = function(ev)
			shadows[ev.buf] = nil
			locked[ev.buf] = nil
		end,
	})
end

M.unlock_all = unlock_all

return M
