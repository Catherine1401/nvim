return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			-- 1. TỐI ƯU HÓA NHÃN (LABELS)
			-- Bỏ các phím khó bấm (z, x, c, m...) ở cuối nếu muốn,
			-- nhưng quan trọng nhất là thứ tự ưu tiên: Home row -> Gần -> Xa
			labels = "asdfghjklqwertyuiopzxcvbnm",

			search = {
				multi_window = true,
				forward = true,
				wrap = true,
				mode = "exact",
				-- Tăng ngưỡng kích hoạt tìm kiếm (nếu file quá lớn)
				-- max_length = false,
			},

			jump = {
				jumplist = true,
				pos = "start",
				history = false,
				register = false,
				nohlsearch = true,
				autojump = false,
			},

			label = {
				-- GIẢI PHÁP 1: Bật chữ hoa (Tăng gấp đôi số lượng nhãn)
				-- Cậu sẽ có thêm A-Z để nhảy tới các vị trí xa
				uppercase = true,

				exclude = "",
				current = true,
				after = true,
				before = false,
				style = "overlay",

				-- GIẢI PHÁP 2: Tái sử dụng nhãn thông minh (Reuse)
				-- "all": Cho phép dùng lại nhãn ở các vị trí an toàn (cách xa nhau)
				reuse = "all",

				-- Ưu tiên điểm gần con trỏ
				distance = true,
				min_pattern_length = 0,
			},

			modes = {
				search = { enabled = true },
				char = {
					enabled = true,
					jump_labels = true,
					autohide = false,
					multi_line = false,
				},
				treesitter = {
					labels = "abcdefghijklmnopqrstuvwxyz",
					jump = { pos = "range" },
					highlight = { backdrop = false, matches = false },
				},
			},
		},

		-- 3. Phím tắt (Keymaps) - Giữ nguyên như cậu đã quen
		keys = {
			{
				"z",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash Jump",
			},
			{
				"Z",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
}
