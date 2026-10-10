-- Sign thay chữ B/C/R/L mặc định: hình Unicode, màu link tới nhóm highlight của theme
local SIGNS = {
	DapBreakpoint = { text = "●", texthl = "DiagnosticError" },
	DapBreakpointCondition = { text = "◆", texthl = "DiagnosticWarn" },
	DapBreakpointRejected = { text = "◇", texthl = "Comment" },
	DapLogPoint = { text = "■", texthl = "DiagnosticInfo" },
	DapStopped = { text = "▶", texthl = "DiagnosticOk", linehl = "DapStoppedLine" },
}

-- Tô nền dòng đang dừng; đặt lại sau mỗi lần đổi colorscheme vì link bị xoá
local function define_signs()
	vim.api.nvim_set_hl(0, "DapStoppedLine", { link = "Visual" })
	for name, sign in pairs(SIGNS) do
		vim.fn.sign_define(name, sign)
	end
end

-- Khi dừng (trừ bước step) báo rõ vị trí và cách chạy tiếp, vì app đứng hình tới khi chạy tiếp; mở UI sau khi nvim-dap đã chuyển tới mã nguồn
local function announce_stop(session, body)
	local function open_ui() require("dapui").open() end
	-- Flutter dừng ngắn lúc khởi động (entry, không có mã nguồn) rồi tự chạy tiếp: không báo, không mở UI
	if body.reason == "entry" then
		return
	end
	if body.reason == "step" then
		return open_ui()
	end
	session:request("stackTrace", { threadId = body.threadId, startFrame = 0, levels = 1 }, function(err, response)
		local frame = not err and response and response.stackFrames[1]
		local path = frame and frame.source and frame.source.path
		local where = path and (vim.fn.fnamemodify(path, ":t") .. ":" .. frame.line) or "vị trí không có mã nguồn"
		vim.schedule(function()
			vim.notify(string.format("Đang dừng ở %s (%s), bấm <leader>kc để chạy tiếp", where, body.reason), vim.log.levels.WARN)
			-- Tới cửa sổ đã hiện mã nguồn (hoặc mở tab mới) trước khi mở UI để UI nằm cùng tab với dòng dừng
			if path then
				vim.cmd("tab drop " .. vim.fn.fnameescape(path))
				pcall(vim.api.nvim_win_set_cursor, 0, { frame.line, 0 })
			end
			open_ui()
		end)
	end)
end

-- Cuộn mọi cửa sổ REPL tới dòng mới nhất khi có output (log của logpoint, print); bỏ qua cửa sổ bạn đang đứng để không giật khi đang đọc
local function follow_repl()
	local current = vim.api.nvim_get_current_win()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if win ~= current and vim.bo[buf].filetype == "dap-repl" then
			pcall(vim.api.nvim_win_set_cursor, win, { vim.api.nvim_buf_line_count(buf), 0 })
		end
	end
end

return {
	"rcarriga/nvim-dap-ui",
	dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	keys = {
		{ "<leader>kb", function() require("dap").toggle_breakpoint() end, desc = "Bật/tắt breakpoint" },
		{ "<leader>kd", function() require("dap").set_breakpoint(vim.fn.input("Điều kiện: ")) end, desc = "Breakpoint có điều kiện" },
		{ "<leader>kp", function() require("config.dap_logpoint").set() end, desc = "Đặt logpoint (in ra REPL, không dừng)" },
		{ "<leader>kl", function() require("dap").list_breakpoints(true) end, desc = "Liệt kê breakpoint" },
		{ "<leader>kx", function() require("dap").clear_breakpoints() end, desc = "Xoá mọi breakpoint" },
		{ "<leader>kc", function() require("dap").continue() end, desc = "Bắt đầu/tiếp tục debug" },
		{ "<leader>kn", function() require("dap").step_over() end, desc = "Bước qua" },
		{ "<leader>ki", function() require("dap").step_into() end, desc = "Bước vào" },
		{ "<leader>ko", function() require("dap").step_out() end, desc = "Bước ra" },
		{ "<leader>ku", function() require("dapui").toggle() end, desc = "Bật/tắt UI debug" },
		{ "<leader>kr", function() require("dap").repl.toggle() end, desc = "Bật/tắt REPL debug" },
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		dapui.setup()
		define_signs()
		vim.api.nvim_create_autocmd("ColorScheme", { group = vim.api.nvim_create_augroup("DapSigns", {}), callback = define_signs })
		-- Luôn chuyển tới cửa sổ/tab có mã nguồn đang dừng (mở tab mới nếu chưa có) thay vì ghi đè cửa sổ trước, ví dụ khi đang đứng ở tab log
		dap.defaults.fallback.switchbuf = "usevisible,usetab,newtab"
		-- Chỉ mở UI khi dừng ở breakpoint, để chạy Flutter qua DAP bình thường không bật UI mỗi lần
		dap.listeners.after.event_stopped["dapui_config"] = announce_stop
		-- Làm mới thanh trạng thái ngay khi phiên dừng hoặc chạy tiếp, để chỉ báo "đang dừng" không trễ tới lần di chuyển con trỏ kế tiếp
		for _, event in ipairs({ "event_stopped", "event_continued", "event_terminated", "event_exited" }) do
			dap.listeners.after[event]["lualine_refresh"] = function()
				vim.schedule(function()
					local ok, lualine = pcall(require, "lualine")
					if ok then
						lualine.refresh()
					end
				end)
			end
		end
		dap.listeners.after.event_output["repl_follow"] = function()
			vim.schedule(follow_repl)
		end
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close
	end,
}
