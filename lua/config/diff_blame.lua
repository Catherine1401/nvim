-- Blame dòng hiện tại của buffer diffview bên bản cũ bằng git blame trên đúng revision
local M = {}

local WINHL = "NormalFloat:DiffBlameFloat,FloatBorder:DiffBlameBorder"

-- Nền gần đen (pha fg của theme với đen) + viền cảnh báo đậm: nổi trên cả nền terminal xanh
local function define_highlights()
	local function get(name)
		return vim.api.nvim_get_hl(0, { name = name, link = false })
	end
	local fg = get("Normal").fg or 0xc8d3f5
	local DARKEN = 0.1
	local function channel(shift)
		return math.floor(bit.band(bit.rshift(fg, shift), 0xff) * DARKEN)
	end
	local bg = channel(16) * 0x10000 + channel(8) * 0x100 + channel(0)
	vim.api.nvim_set_hl(0, "DiffBlameFloat", { bg = bg, fg = fg })
	vim.api.nvim_set_hl(0, "DiffBlameBorder", { bg = bg, fg = get("DiagnosticWarn").fg or 0xe0af68, bold = true })
end

-- Áp màu nổi bật cho float blame của cả gitsigns lẫn blame bản cũ
function M.setup()
	define_highlights()
	vim.api.nvim_create_autocmd("ColorScheme", { callback = define_highlights })
	vim.api.nvim_create_autocmd("WinNew", {
		callback = function()
			-- Float gitsigns được đánh dấu vim.w.gitsigns_preview sau khi cửa sổ tạo xong
			vim.schedule(function()
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					if vim.w[win].gitsigns_preview then
						vim.wo[win].winhighlight = WINHL
					end
				end
			end)
		end,
	})
end

function M.show()
	local origin = vim.b.diff_origin
	local line = vim.fn.line(".")
	local cmd = { "git", "-C", vim.fs.dirname(origin.path), "blame", "-L", line .. "," .. line, "--date=short" }
	local stdin
	if origin.rev:find("^:") then
		-- Bản index không có commit: blame nội dung buffer so với lịch sử HEAD
		vim.list_extend(cmd, { "--contents", "-" })
		stdin = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n") .. "\n"
	else
		cmd[#cmd + 1] = origin.rev
	end
	vim.list_extend(cmd, { "--", origin.path })
	vim.system(cmd, { text = true, stdin = stdin }, vim.schedule_wrap(function(res)
		if res.code ~= 0 then
			vim.notify("git blame: " .. vim.trim(res.stderr), vim.log.levels.ERROR)
			return
		end
		local _, win = vim.lsp.util.open_floating_preview({ vim.trim(res.stdout) }, "", { border = "double", focus_id = "diff_blame" })
		vim.wo[win].winhighlight = WINHL
	end))
end

return M
