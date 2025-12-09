return {
	{
		"stevearc/oil.nvim",
		-- Cần plugin icon để giao diện đẹp hơn
		dependencies = { "nvim-tree/nvim-web-devicons" },

		config = function()
			require("oil").setup({
				-- 1. CẤU HÌNH CỐT LÕI
				-- Thay thế hoàn toàn netrw (trình quản lý file mặc định cũ kỹ)
				default_file_explorer = true,

				-- Giao diện cột: Chỉ hiện icon để gọn gàng
				columns = {
					"icon",
					-- "permissions", -- Bật nếu cậu muốn xem quyền file (rwx)
					-- "size",        -- Bật nếu muốn xem dung lượng
					-- "mtime",       -- Bật nếu muốn xem thời gian sửa
				},

				-- 2. TÍNH NĂNG REFACTOR (QUAN TRỌNG NHẤT VỚI CẬU)
				-- Giúp tự động sửa import khi Move/Rename file
				lsp_file_methods = {
					enabled = true, -- Bật tính năng này
					timeout_ms = 10000,
					autosave_changes = false, -- false: Hiện bảng xác nhận thay đổi (An toàn)
				},

				-- 3. CƠ CHẾ XÓA FILE
				-- false: Xóa vĩnh viễn (Cẩn thận!)
				-- true: Chuyển vào thùng rác (Cần cài thêm tool trash-cli trên Linux, Windows thì tùy setup)
				-- Tớ để false mặc định để đảm bảo hoạt động, cậu dùng cẩn thận nhé.
				delete_to_trash = false,

				-- Luôn hỏi xác nhận khi thao tác để tránh lỡ tay
				skip_confirm_for_simple_edits = false,

				-- 4. TÙY CHỈNH GIAO DIỆN (VIEW)
				view_options = {
					-- Hiện file ẩn (bắt đầu bằng dấu chấm như .gitignore, .env)
					show_hidden = true,

					-- Nhưng luôn ẩn 2 cái này cho đỡ rối mắt
					is_always_hidden = function(name, _)
						return name == ".." or name == ".git"
					end,

					-- Sắp xếp tự nhiên (file1, file2, file10 thay vì file1, file10, file2)
					natural_order = true,
				},

				-- 5. CẤU HÌNH CỬA SỔ NỔI (FLOAT)
				float = {
					padding = 2,
					max_width = 90,
					max_height = 0, -- Tự động theo nội dung
					border = "rounded", -- Viền bo tròn
					win_options = {
						winblend = 0,
					},
				},

				-- 6. PHÍM TẮT TRONG OIL (KEYMAPS)
				keymaps = {
					["g?"] = "actions.show_help", -- Xem giúp đỡ
					["<CR>"] = "actions.select", -- Vào thư mục / Mở file
					["<C-s>"] = "actions.select_vsplit", -- Mở file chia dọc
					["<C-h>"] = "actions.select_split", -- Mở file chia ngang
					["<C-t>"] = "actions.select_tab", -- Mở file tab mới
					["<C-p>"] = "actions.preview", -- Xem trước file
					["<C-c>"] = "actions.close", -- Đóng Oil
					["<C-l>"] = "actions.refresh", -- Làm mới
					["-"] = "actions.parent", -- Lên thư mục cha
					["_"] = "actions.open_cwd", -- Mở thư mục hiện tại của nvim
					["`"] = "actions.cd", -- Chuyển root vào thư mục đang đứng
					["~"] = "actions.tcd", -- Chuyển root (tab local)
					["gs"] = "actions.change_sort", -- Đổi kiểu sắp xếp
					["gx"] = "actions.open_external", -- Mở bằng phần mềm ngoài
					["g."] = "actions.toggle_hidden", -- Ẩn/Hiện file hidden
				},
			})

			-- === PHÍM TẮT TOÀN CỤC (GLOBAL KEYMAPS) ===
			-- 1. Bấm dấu trừ (-) để mở folder cha (Giống vim-vinegar huyền thoại)
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open Parent Directory" })

			-- 2. Bấm <leader>e để mở Oil dạng cửa sổ nổi (Đẹp hơn)
			vim.keymap.set("n", "<leader>i", "<CMD>Oil --float<CR>", { desc = "Open File Manager (Float)" })
		end,
	},
}
