return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy", -- Load sau cùng để không chặn khởi động
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300 -- Thời gian chờ 300ms là chuẩn vàng
		end,
		opts = {
			-- 1. CẤU HÌNH GIAO DIỆN (UI)
			-- Dùng preset 'modern' cho đẹp (có viền bo, màu sắc dịu)
			preset = "modern",

			-- Tùy chỉnh độ trễ hiển thị
			delay = function(ctx)
				return ctx.plugin and 0 or 200
			end,

			-- Cấu hình cửa sổ popup
			win = {
				border = "rounded", -- Viền bo tròn đồng bộ với hệ thống
				padding = { 1, 2 }, -- Khoảng cách lề cho thoáng
				title = true, -- Hiện tiêu đề phím đang ấn
			},

			-- Cấu hình Icon
			icons = {
				breadcrumb = "»", -- Dấu phân cách breadcrumb
				separator = "➜", -- Dấu mũi tên chỉ dẫn
				group = "+", -- Dấu cộng cho nhóm (folder)
				rules = false, -- Tắt rules tự động nếu cậu muốn tự kiểm soát icon
			},

			-- 2. ĐỊNH NGHĨA NHÓM PHÍM (SPEC V3)
			-- Đây là cú pháp mới nhất của WhichKey v3
			spec = {
				{
					mode = { "n", "v" }, -- Áp dụng cho Normal và Visual mode

					-- Nhóm các phím chức năng lại với nhau
					{ "<leader>b", group = "Buffer" },
					{ "<leader>c", group = "Code" },
					{ "<leader>f", group = "File/Find" },
					{ "<leader>g", group = "Git" },
					{ "<leader>gh", group = "Git Hunks" }, -- Nhóm con của Git
					{ "<leader>q", group = "Quit/Session" },
					{ "<leader>s", group = "Search" },
					{ "<leader>u", group = "UI" },
					{ "<leader>t", group = "Terminal" },
					{ "<leader>w", group = "Windows" },
					{ "<leader>x", group = "Diagnostics/Quickfix" },

					-- Nhóm riêng cho Flutter (Cậu là Flutter dev mà)
					{ "<leader>F", group = "Flutter Tools", icon = " " },
				},

				-- Ẩn các phím không cần thiết khỏi menu (cho gọn)
				{ "<leader>1", hidden = true },
				{ "<leader>2", hidden = true },
				{ "<leader>3", hidden = true },
				{ "<leader>4", hidden = true },
				{ "<leader>5", hidden = true },
			},
		},

		-- Cấu hình phím tắt kích hoạt thủ công
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (Which-Key)",
			},
		},
	},
}
