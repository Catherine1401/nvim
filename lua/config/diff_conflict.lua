-- Phím chọn xung đột của diffview chỉ làm việc khi con trỏ cửa sổ kết quả nằm trong khối và im lặng nếu không
local M = {}

-- Khối xung đột dưới con trỏ của cửa sổ kết quả, nil nếu con trỏ ở ngoài khối
local function current_block()
	local view = require("diffview.lib").get_current_view()
	if not view then
		return nil
	end
	local main = view.cur_layout:get_main_win()
	local lines = vim.api.nvim_buf_get_lines(main.file.bufnr, 0, -1, false)
	local _, cur = require("diffview.vcs.utils").parse_conflicts(lines, main.id)
	return cur
end

-- Chọn phiên bản cho khối dưới con trỏ; ngoài khối thì nhảy tới khối kế tiếp và báo để bấm lại
function M.choose(target)
	return function()
		local actions = require("diffview.actions")
		if current_block() then
			return actions.conflict_choose(target)()
		end
		if actions.next_conflict() then
			vim.notify("Con trỏ chưa ở trong khối xung đột, đã nhảy tới khối kế tiếp; bấm lại để chọn", vim.log.levels.INFO)
		else
			vim.notify("File này không còn khối xung đột", vim.log.levels.INFO)
		end
	end
end

return M
