return {
	-- Khai báo plugin và phiên bản
	{
		"akinsho/toggleterm.nvim",
		version = "*",

		-- Cấu hình plugin
		opts = {
			-- ĐÃ ĐỔI: Chuyển từ "powershell.exe" sang "zsh" để chạy được trên Arch Linux
			shell = "zsh",

			-- 1. Kích thước (Size):
			size = function(term)
				if term.direction == "horizontal" then
					return 15 -- Chiều cao 15 hàng nếu chia ngang
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4 -- Chiều rộng 40% nếu chia dọc
				end
				return 20 -- Mặc định là 20
			end,

			-- 2. Phím tắt mở (Open Mapping):
			-- open_mapping = [[<C-\>]],

			-- 3. Chế độ (Mode)
			start_in_insert = true, -- Bắt đầu trong chế độ Insert mode ngay khi mở
			insert_mappings = true, -- Áp dụng phím tắt mở trong Insert mode
			terminal_mappings = true, -- Áp dụng phím tắt mở ngay cả trong terminal mode
			persist_mode = true, -- Ghi nhớ chế độ (Normal/Insert) trước đó

			-- 4. Hướng mặc định (Default Direction):
			direction = "float", -- Mặc định mở dưới dạng cửa sổ nổi (float)

			-- 5. Bóng/Màu sắc (Shading/Highlights):
			shade_terminals = true, -- Tự động làm tối nền terminal
			hide_numbers = true, -- Ẩn cột số dòng

			-- 6. Tùy chọn cửa sổ nổi (Float Options):
			float_opts = {
				border = "curved", -- Đặt viền cong cho cửa sổ nổi
				winblend = 3, -- Độ trong suốt (Kết hợp rất đẹp với Alacritty 0.85 của cậu)
			},

			-- 7. Tùy chọn khác
			close_on_exit = true, -- Tự động đóng terminal khi tiến trình kết thúc
			auto_scroll = true, -- Tự động cuộn xuống dưới khi có output mới
		},

		-- Hàm config (được gọi sau khi plugin được tải)
		config = function(_, opts)
			-- Tớ giữ nguyên biến term_opts và phím tắt của cậu
			local term_opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", term_opts)
			require("toggleterm").setup(opts)

			-- 🌷 Tùy chọn bổ sung: Thiết lập Keymaps trong Terminal mode 🌷
			function set_terminal_keymaps()
				local opts = { buffer = 0 }
				-- Thoát Terminal mode
				vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts) -- Dùng Esc
				vim.keymap.set("n", "jk", [[<C-w>h]], opts) -- Dùng jk (giống Vim)
			end

			-- Tự động chạy hàm thiết lập keymaps khi mở một terminal
			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

			-- 🌷 Cấu hình Custom Terminal (Ví dụ: LazyGit) 🌷
			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({
				cmd = "lazygit",
				hidden = true,
				direction = "float",
				float_opts = { border = "double" },
			})
		end,
	},
}
