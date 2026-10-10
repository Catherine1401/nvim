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

return {
	"rcarriga/nvim-dap-ui",
	dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	keys = {
		{ "<leader>kb", function() require("dap").toggle_breakpoint() end, desc = "Bật/tắt breakpoint" },
		{ "<leader>kB", function() require("dap").set_breakpoint(vim.fn.input("Điều kiện: ")) end, desc = "Breakpoint có điều kiện" },
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
		-- Chỉ mở UI khi dừng ở breakpoint, để chạy Flutter qua DAP bình thường không bật UI mỗi lần
		dap.listeners.after.event_stopped["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close
	end,
}
