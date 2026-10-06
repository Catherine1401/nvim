-- Cuộn ngang mượt theo easing cubic của neoscroll: vị trí tại thời điểm t là 1 - (1 - t)^3 (nghịch đảo của ease)
local M = {}

local TICK_MS = 8 -- nhịp cập nhật; mỗi nhịp đi bù đủ số cột theo thời gian đã trôi

local timer = vim.uv.new_timer()
local scroll = { total = 0, done = 0, duration = 0, started = 0, cursorline = nil }

local function now_ms()
	return vim.uv.hrtime() / 1e6
end

-- Số cột đáng lẽ đã đi sau elapsed ms, giống đường cong của neoscroll cubic (nhanh rồi chậm dần)
local function target_at(elapsed)
	if elapsed >= scroll.duration then
		return scroll.total
	end
	local x = 1 - math.pow(1 - elapsed / scroll.duration, 3)
	return math.floor(scroll.total * x + (scroll.total > 0 and 0.5 or -0.5))
end

local function finish()
	timer:stop()
	scroll.total, scroll.done = 0, 0
	if scroll.cursorline ~= nil then
		vim.wo.cursorline = scroll.cursorline
		scroll.cursorline = nil
	end
end

local step

local function schedule()
	timer:start(TICK_MS, 0, vim.schedule_wrap(step))
end

step = function()
	local target = target_at(now_ms() - scroll.started)
	local delta = target - scroll.done
	if delta ~= 0 then
		local before = vim.fn.winsaveview().leftcol
		pcall(vim.cmd.normal, { args = { math.abs(delta) .. (delta > 0 and "zl" or "zh") }, bang = true })
		local moved = vim.fn.winsaveview().leftcol - before
		scroll.done = scroll.done + moved
		-- Không dịch được đủ (hết dòng hoặc về mép trái) thì dừng, như stop_eof của neoscroll
		if math.abs(moved) < math.abs(delta) then
			return finish()
		end
	end
	if scroll.done == scroll.total then
		return finish()
	end
	schedule()
end

-- Cuộn cols cột (dương: sang phải, âm: sang trái) trong duration ms; bấm tiếp thì cộng dồn phần còn lại
function M.scroll(cols, duration)
	if cols == 0 then
		return
	end
	if scroll.total == 0 then
		scroll.cursorline = vim.wo.cursorline
		vim.wo.cursorline = false
	end
	scroll.total = cols + scroll.total - scroll.done
	scroll.done = 0
	scroll.duration = duration
	scroll.started = now_ms()
	timer:stop()
	schedule()
end

-- Số cột theo tỉ lệ chiều rộng cửa sổ, count (nếu có) là số cột cụ thể như zl/zh gốc
function M.by_width(ratio, sign, duration)
	local cols = vim.v.count > 0 and vim.v.count or math.max(1, math.floor(vim.api.nvim_win_get_width(0) * ratio + 0.5))
	M.scroll(sign * cols, duration)
end

return M
