-- nvim-dap nạp lười (flutter-tools không còn nạp sẵn); giữ các lệnh :Dap* dùng được ngay từ đầu
return {
	"mfussenegger/nvim-dap",
	lazy = true,
	cmd = {
		"DapClearBreakpoints",
		"DapContinue",
		"DapDisconnect",
		"DapEval",
		"DapNew",
		"DapPause",
		"DapRestartFrame",
		"DapSetLogLevel",
		"DapShowLog",
		"DapStepInto",
		"DapStepOut",
		"DapStepOver",
		"DapTerminate",
		"DapToggleBreakpoint",
		"DapToggleRepl",
	},
}
