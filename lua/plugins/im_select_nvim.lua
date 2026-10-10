return {
	"keaising/im-select.nvim",
	-- Nạp sau màn hình đầu; rời Insert/Cmdline thì chuyển ibus về tiếng Anh, vào Insert thì khôi phục engine trước đó
	event = "VeryLazy",
	config = function()
		local SETTLE_MS = 150 -- lệnh chuyển engine chạy nền mất tối đa khoảng 50 ms
		local last_switch = 0
		local group = vim.api.nvim_create_augroup("ImSelectRestore", {})
		-- Bỏ CmdlineLeave khỏi sự kiện mặc định: handler của plugin ghi đè engine đã nhớ bằng engine hiện tại (tiếng Anh) nên sau mỗi lệnh : vào Insert không về lại Bamboo
		require("im_select").setup({ set_default_events = { "InsertLeave" } })
		-- Đang ở Normal lúc khởi động: chuyển về tiếng Anh ngay và nhớ engine hiện tại (chỉ chạy handler của plugin)
		pcall(vim.api.nvim_exec_autocmds, "InsertLeave", { group = "im-select" })
		-- Ghi lại lần chuyển engine gần nhất của plugin để biết khi thoát còn lệnh nền đang chạy hay không
		vim.api.nvim_create_autocmd("InsertLeave", {
			group = group,
			callback = function()
				last_switch = vim.uv.hrtime()
			end,
		})
		-- Thoát nvim thì trả lại engine đã nhớ; chờ lệnh chuyển nền của InsertLeave xong trước (Esc rồi thoát ngay) kẻo nó ghi đè
		vim.api.nvim_create_autocmd("VimLeavePre", {
			group = group,
			callback = function()
				local saved = vim.g.im_select_saved_state
				if not saved or saved == "" or vim.fn.executable("ibus") ~= 1 then
					return
				end
				local remaining = SETTLE_MS - (vim.uv.hrtime() - last_switch) / 1e6
				if remaining > 0 then
					vim.wait(remaining)
				end
				vim.fn.system({ "ibus", "engine", saved })
			end,
		})
	end,
}
