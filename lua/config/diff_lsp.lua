-- Diffview: buffer diffview:// mượn tên file anh em trong project để LSP thật gắn vào, và mọi buffer diff chỉ đọc
local M = {}

local shadows = {} -- buffer diffview:// đã đổi tên -> true
local locked = {} -- buffer file thật đã khoá -> { modifiable, readonly }

-- Tên file thật + rev từ tên buffer diffview://<root>/.git/<rev>/<path> (rev là hash hoặc :0:)
local function parse_name(name)
	local root, rev, path = name:match("^diffview://(.-)/%.git/([^/]+)/(.+)$")
	if not root then
		return nil
	end
	return root .. "/" .. path, rev
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

local function unlock_all()
	for buf, state in pairs(locked) do
		if vim.api.nvim_buf_is_valid(buf) then
			vim.bo[buf].modifiable = state.modifiable
			vim.bo[buf].readonly = state.readonly
		end
	end
	locked = {}
end

-- Hook diffview: buffer vào cửa sổ diff
function M.on_buf_enter(buf)
	if vim.api.nvim_buf_get_name(buf):find("^diffview://") then
		prepare_shadow(buf)
	end
	lock(buf)
end

-- Mở khoá rồi mở file thật để sửa tại dòng đang đứng
function M.goto_edit()
	unlock_all()
	require("diffview.actions").goto_file_edit()
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
	vim.api.nvim_create_autocmd("BufWipeout", {
		callback = function(ev)
			shadows[ev.buf] = nil
			locked[ev.buf] = nil
		end,
	})
end

M.unlock_all = unlock_all

return M
