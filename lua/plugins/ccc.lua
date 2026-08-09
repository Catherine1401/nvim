-- color picker
return {
	"uga-rosa/ccc.nvim",
	version = "*",

	-- 1. Hàm init: Yêu cầu bắt buộc kích hoạt True Color (theo ccc-setup)
	init = function()
		-- Enable true color
		vim.opt.termguicolors = true
	end,

	-- 2. Cấu hình (Options) - Sử dụng hàm để trì hoãn việc gọi require("ccc")
	opts = function()
		-- ✨ Khai báo module ccc ở đây để đảm bảo plugin đã được tải trước khi gọi các submodule
		local ccc = require("ccc")

		-- 🌟 Cấu hình HEX Output dùng chữ in hoa
		local hex_uppercase = ccc.output.hex
		hex_uppercase.setup({ uppercase = true })

		return {
			-- 🖼️ Tùy chọn UI và cửa sổ
			win_opts = {
				relative = "cursor",
				border = "rounded",
			},

			-- 💾 Tùy chọn Persistent Colors
			preserve = true, -- Giữ lại màu đã chọn trước đó
			save_on_quit = true, -- Lưu màu hiện tại vào lịch sử khi thoát bằng 'q'

			-- ✨ Tùy chỉnh hiển thị thanh trượt
			empty_point_bg = false, -- Làm nền con trỏ liên tục với thanh trượt

			-- 🌟 Cấu hình Highlighter
			highlighter = {
				auto_enable = true, -- Tự động bật tính năng highlight khi mở buffer
				lsp = true, -- Dùng LSP để phát hiện màu sắc
				filetypes = { "css", "scss", "less", "html", "javascript", "typescript", "lua" },
				update_insert = true, -- Cập nhật highlight ngay cả khi đang ở Insert mode
			},

			-- 💡 Chế độ Tô sáng (Virtual Text)
			highlight_mode = "virtual", -- Dùng văn bản ảo (virtual text)
			virtual_symbol = " ◆ ", -- Ký hiệu hiển thị
			virtual_pos = "inline-right", -- Đặt ký hiệu ở bên phải mã màu

			-- 🎨 Cấu hình Input
			inputs = {
				ccc.input.rgb,
				ccc.input.hsl,
				ccc.input.hwb,
				ccc.input.cmyk,
			},

			-- 🧾 Cấu hình Output
			outputs = {
				hex_uppercase, -- HEX với chữ in hoa
				ccc.output.hex_short,
				ccc.output.css_rgb,
				ccc.output.css_rgba,
				ccc.output.css_hsl,
			},

			-- 🔄 Cấu hình Convert
			convert = {
				{ ccc.picker.hex, ccc.output.css_rgb },
				{ ccc.picker.css_rgb, ccc.output.css_hsl },
				{ ccc.picker.css_hsl, ccc.output.hex },
				-- Thêm tùy chọn chuyển đổi sang RGBA
				{ ccc.picker.hex, ccc.output.css_rgba },
			},

			-- 🧠 Cấu hình Recognize
			recognize = {
				input = true, -- Tự động chuyển Input mode
				output = true, -- Tự động chuyển Output mode
			},
		}
	end,

	-- 3. Thiết lập Phím Tắt (Keymaps)
	keys = {
		-- Mở Picker và tự động dò màu dưới con trỏ
		{
			"<leader>cp",
			"<Cmd>CccPick<CR>",
			mode = "n",
			desc = "Open Color Picker (CccPick)",
		},
		-- Chuyển đổi format màu nhanh
		{
			"<leader>cc",
			"<Cmd>CccConvert<CR>",
			mode = "n",
			desc = "Convert Color Format",
		},
		-- Bật/Tắt Highlighter thủ công
		{
			"<leader>ct",
			"<Cmd>CccHighlighterToggle<CR>",
			mode = "n",
			desc = "Toggle Color Highlighter",
		},
	},
}
