return {
	-- Khai báo plugin và phiên bản
	{
		"akinsho/toggleterm.nvim",
		version = "*",

		-- Cấu hình plugin
		opts = {
			shell = "powershell.exe",
			-- 1. Kích thước (Size):
			-- Tùy chỉnh kích thước cửa sổ terminal. Ở đây, tớ dùng ví dụ mặc định
			-- cho biết cách đặt kích thước theo hướng chia.
			size = function(term)
				if term.direction == "horizontal" then
					return 15 -- Chiều cao 15 hàng nếu chia ngang
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4 -- Chiều rộng 40% nếu chia dọc
				end
				return 20 -- Mặc định là 20
			end,

			-- 2. Phím tắt mở (Open Mapping):
			-- Phím tắt để bật/tắt terminal. Mặc định dùng <C-\> (Ctrl + \)
			-- open_mapping = [[<C-\>]],

			-- 3. Chế độ (Mode)
			start_in_insert = true, -- Bắt đầu trong chế độ Insert mode ngay khi mở
			insert_mappings = true, -- Áp dụng phím tắt mở trong Insert mode
			terminal_mappings = true, -- Áp dụng phím tắt mở ngay cả trong terminal mode
			persist_mode = true, -- Ghi nhớ chế độ (Normal/Insert) trước đó

			-- 4. Hướng mặc định (Default Direction):
			direction = "float", -- Mặc định mở dưới dạng cửa sổ nổi (float)
			-- Cậu có thể thay bằng 'vertical', 'horizontal'

			-- 5. Bóng/Màu sắc (Shading/Highlights):
			shade_terminals = true, -- Tự động làm tối nền terminal
			hide_numbers = true, -- Ẩn cột số dòng

			-- 6. Tùy chọn cửa sổ nổi (Float Options):
			float_opts = {
				border = "curved", -- Đặt viền cong cho cửa sổ nổi
				winblend = 3, -- Độ trong suốt
			},

			-- 7. Tùy chọn khác
			close_on_exit = true, -- Tự động đóng terminal khi tiến trình kết thúc
			auto_scroll = true, -- Tự động cuộn xuống dưới khi có output mới
		},

		-- Hàm config (được gọi sau khi plugin được tải)
		config = function(_, opts)
			vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", term_opts)
			require("toggleterm").setup(opts)

			-- 🌷 Tùy chọn bổ sung: Thiết lập Keymaps trong Terminal mode 🌷
			-- Điều này rất quan trọng để có thể di chuyển ra khỏi terminal
			-- mà không đóng nó, hoặc di chuyển giữa các cửa sổ Neovim.
			function set_terminal_keymaps()
				local term_opts = { buffer = 0 }
				-- Thoát Terminal mode
				vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], term_opts) -- Dùng Esc
				vim.keymap.set("n", "jk", [[<C-w>h]], term_opts) -- Dùng jk (giống Vim)

				-- Di chuyển giữa các cửa sổ (windows) mà không thoát terminal
				-- vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], term_opts)
				-- vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], term_opts)
				-- vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], term_opts)
				-- vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], term_opts)
			end

			-- Tự động chạy hàm thiết lập keymaps khi mở một terminal
			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

			-- 🌷 Cấu hình Custom Terminal (Ví dụ: LazyGit) 🌷
			-- Tạo một terminal riêng để chạy LazyGit (hoặc htop,...)
			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({
				cmd = "lazygit",
				hidden = true, -- Không bị ảnh hưởng bởi ToggleTerm chung
				direction = "float",
				float_opts = { border = "double" },
			})

			-- Thiết lập phím tắt riêng để bật/tắt LazyGit
			-- vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua lazygit:toggle()<CR>", {noremap = true, silent = true, desc = "Toggle LazyGit"})
		end,
	},
}
