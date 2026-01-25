return {
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				-- Gán các phím tắt của cậu
				keymaps = {
					accept_suggestion = "<M-k>", -- Alt + k: Nhận toàn bộ
					accept_word = "<M-w>", -- Alt + w: Nhận từng từ (Accept Word)
					clear_suggestion = "<M-c>", -- Alt + c: Xóa gợi ý

					-- BỔ SUNG THEO YÊU CẦU CỦA CẬU:
					accept_line = "<M-l>", -- Alt + l: Nhận từng dòng (Accept Line)
					-- Lưu ý: Supermaven bản nvim hiện chưa hỗ trợ phím tắt mặc định cho cycle (đổi gợi ý)
					-- trong bảng keymaps của setup, nhưng mình sẽ dùng lệnh hoặc phím tắt bên dưới.
				},

				color = {
					suggestion_color = "#808080",
					cterm = 244,
				},
				disable_inline_completion = false,
				disable_keymaps = false,
			})

			-- Cấu hình phím tắt bổ sung cho Bật/Tắt và Đổi gợi ý
			local api = require("supermaven-nvim.api")

			-- Alt + t để Bật/Tắt gợi ý (Toggle)
			vim.keymap.set("n", "<M-t>", function()
				api.toggle()
				vim.notify("Supermaven: " .. (api.is_running() and "Đã bật" or "Đã tắt"))
			end, { desc = "Supermaven Toggle" })

			-- Đối với việc đổi gợi ý khác (Cycle):
			-- Hiện tại Supermaven tập trung vào 1 gợi ý duy nhất có độ chính xác cao nhất (fastest),
			-- Nếu cậu muốn thử gợi ý khác, cậu có thể gõ tiếp để AI tự điều chỉnh theo ngữ cảnh mới.
		end,
	},
}
