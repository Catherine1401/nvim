return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		-- Giữ nguyên phần icon đẹp của cậu
		vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
		vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
		vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
		vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

		require("neo-tree").setup({
			-- 1. CẤU HÌNH CHUNG
			close_if_last_window = true,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,

			-- 2. THANH CHUYỂN ĐỔI (SOURCE SELECTOR)
			source_selector = {
				winbar = true,
				statusline = false,
			},

			-- 3. CẤU HÌNH CỬA SỔ (WINDOW)
			window = {
				position = "left",
				width = 30,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					-- Tớ giữ nguyên toàn bộ phím tắt cậu đã quen dùng
					["<space>"] = { "toggle_node", nowait = false },
					["<2-LeftMouse>"] = "open",
					["<cr>"] = "open",
					["<esc>"] = "cancel",
					["P"] = { "toggle_preview", config = { use_float = true } },
					["l"] = "open",
					["S"] = "open_split",
					["s"] = "open_vsplit",
					["t"] = "open_tabnew",
					["C"] = "close_node",
					["z"] = "close_all_nodes",
					["a"] = { "add", config = { show_path = "none" } },
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["c"] = "copy",
					["m"] = "move",
					["q"] = "close_window",
					["R"] = "refresh",
					["?"] = "show_help",
					["Z"] = "expand_all_nodes",
				},
			},

			-- 4. CẤU HÌNH HỆ THỐNG FILE (FILESYSTEM) - PHẦN ĐÃ SỬA CHO WINDOWS
			filesystem = {
				filtered_items = {
					visible = false, -- Cho phép hiện file ẩn nếu muốn
					hide_dotfiles = true,
					hide_gitignored = true,
					-- THÊM VÀO: Chặn các file rác gây lỗi crash trên Windows
					hide_by_pattern = {
						"*.meta",
						"*/.git/*",
						".git_*", -- Quan trọng: Chặn file git_hidden_message gây lỗi
					},
				},
				follow_current_file = {
					enabled = true,
					leave_dirs_open = false,
				},
				-- THAY ĐỔI QUAN TRỌNG: Tắt libuv watcher để tránh lỗi "duplicate node id"
				use_libuv_file_watcher = false,
				hijack_netrw_behavior = "open_default",
			},

			-- 5. CẤU HÌNH GIT STATUS (Giữ nguyên)
			git_status = {
				window = {
					position = "float",
					mappings = {
						["A"] = "git_add_all",
						["gu"] = "git_unstage_file",
						["ga"] = "git_add_file",
						["gc"] = "git_commit",
						["gp"] = "git_push",
						["gg"] = "git_commit_and_push",
					},
				},
			},
		})
	end,
}
