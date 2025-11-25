return {
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*",
		lazy = true,
		event = {
			"BufReadPre C:/Users/hw/obsidian/**.md",
			"BufNewFile C:/Users/hw/obsidian/**.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"saghen/blink.cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},

		opts = {
			-- 1. WORKSPACE
			workspaces = {
				{
					name = "personal",
					path = "C:/Users/hw/obsidian",
				},
			},

			-- 2. KHẮC PHỤC CẢNH BÁO DEPRECATED (QUAN TRỌNG)
			legacy_commands = false, -- Tắt các lệnh kiểu cũ (ObsidianNew...)

			-- 3. CÁC CẤU HÌNH KHÁC (Giữ nguyên)
			ui = { enable = false },
			completion = { nvim_cmp = false, min_chars = 2 },
			daily_notes = { folder = "dailies", date_format = "%Y-%m-%d", template = nil },

			note_id_func = function(title)
				if title then
					return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					return tostring(os.time()) .. "-" .. string.char(math.random(65, 90))
				end
			end,

			attachments = { img_folder = "assets/imgs" },
		},

		config = function(_, opts)
			require("obsidian").setup(opts)

			-- Gán phím tắt thông minh khi mở file Markdown
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(event)
					-- Go to File (Sửa lỗi E447)
					vim.keymap.set("n", "gf", function()
						if require("obsidian").util.cursor_on_markdown_link() then
							return "<cmd>Obsidian follow_link<CR>" -- Cập nhật lệnh mới
						else
							return "gf"
						end
					end, { buffer = event.buf, expr = true, noremap = false, desc = "Follow Link" })

					-- Smart Enter
					vim.keymap.set("n", "<cr>", function()
						return require("obsidian").util.smart_action()
					end, { buffer = event.buf, desc = "Obsidian Smart Action" })
				end,
			})
		end,

		-- 4. CẬP NHẬT PHÍM TẮT TOÀN CỤC (THEO CHUẨN MỚI)
		keys = {
			-- Cú pháp cũ: ObsidianNew -> Cú pháp mới: Obsidian new
			{ "<leader>on", "<cmd>Obsidian new<cr>", desc = "Tạo Note mới" },
			{ "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Mở trong App Obsidian" },
			{ "<leader>os", "<cmd>Obsidian search<cr>", desc = "Tìm kiếm Note (Grep)" },
			{ "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Chuyển Note nhanh" },
			{ "<leader>od", "<cmd>Obsidian today<cr>", desc = "Daily Note hôm nay" },
			{ "<leader>ot", "<cmd>Obsidian template<cr>", desc = "Chèn Template" },
		},
	},
}
