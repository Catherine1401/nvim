return {
	"keaising/im-select.nvim",
	-- Nạp sau màn hình đầu; rời Insert thì chuyển bộ gõ (ibus hoặc fcitx5, plugin tự nhận) về tiếng Anh, vào Insert thì khôi phục engine trước đó
	event = "VeryLazy",
	config = function()
		-- Bỏ CmdlineLeave khỏi sự kiện mặc định: handler của plugin ghi đè engine đã nhớ bằng engine hiện tại (tiếng Anh) nên sau mỗi lệnh : vào Insert không về lại engine tiếng Việt
		require("im_select").setup({ set_default_events = { "InsertLeave" } })
		-- Đang ở Normal lúc khởi động: chuyển về tiếng Anh ngay và nhớ engine hiện tại (chỉ chạy handler của plugin)
		pcall(vim.api.nvim_exec_autocmds, "InsertLeave", { group = "im-select" })
	end,
}
