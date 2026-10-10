-- Logpoint: hỏi nội dung log và gợi ý Tab các tên có trong file (Vim sắp xếp gợi ý theo chữ cái, nên gõ vài chữ đầu rồi Tab)
local M = {}

local MIN_WORD_LENGTH = 2
local KEYWORDS = {
	final = true, var = true, const = true, ["return"] = true, class = true, void = true,
	int = true, double = true, bool = true, String = true, null = true, ["true"] = true,
	["false"] = true, this = true, super = true, extends = true, override = true, import = true,
}

local words = {} -- tên trong buffer, chuẩn bị lúc bắt đầu hỏi

-- Mọi tên (từ 2 ký tự, bỏ từ khoá) có trong buffer, không trùng
local function buffer_words(buf)
	local seen, found = {}, {}
	for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
		for word in line:gmatch("[%a_][%w_]*") do
			if #word >= MIN_WORD_LENGTH and not seen[word] and not KEYWORDS[word] then
				seen[word] = true
				found[#found + 1] = word
			end
		end
	end
	return found
end

-- Hàm gợi ý của input(): phần sau dấu { cuối (hoặc cả từ) khớp một đoạn của tên thì trả về dạng {tên}
function M.complete(arglead)
	local prefix = arglead:gsub("^.*{", "")
	local head = arglead:sub(1, #arglead - #prefix)
	local open = head:sub(-1) == "{" and "" or "{"
	local matches = {}
	for _, word in ipairs(words) do
		if word:lower():find(prefix:lower(), 1, true) then
			matches[#matches + 1] = head .. open .. word .. "}"
		end
	end
	return matches
end

function M.set()
	words = buffer_words(vim.api.nvim_get_current_buf())
	local message = vim.fn.input({
		prompt = "Nội dung log ({biểu thức}, Tab gợi ý tên): ",
		completion = "customlist,v:lua.require'config.dap_logpoint'.complete",
	})
	if message ~= "" then
		require("dap").set_breakpoint(nil, nil, message)
	end
end

return M
