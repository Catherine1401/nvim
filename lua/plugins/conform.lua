-- format code
return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" }, -- Load khi chuẩn bị lưu file
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Phím tắt Format thủ công
				"grf",
				function()
					local opts = { async = true, lsp_format = "fallback" }
					local mode = vim.fn.mode()
					if mode == "v" or mode == "V" then
						-- Tự tính range vì conform trừ 1 ở cột cuối nên stylua bỏ sót câu lệnh cuối
						local from, to = vim.fn.getpos("v"), vim.fn.getpos(".")
						if from[2] > to[2] or (from[2] == to[2] and from[3] > to[3]) then
							from, to = to, from
						end
						local last = vim.api.nvim_buf_get_lines(0, to[2] - 1, to[2], true)[1]
						local start_col = mode == "V" and 0 or from[3] - 1
						local end_col = mode == "V" and #last or to[3]
						opts.range = { start = { from[2], start_col }, ["end"] = { to[2], end_col } }
					end
					require("conform").format(opts)
				end,
				mode = "",
				desc = "Format Code",
			},
		},
		opts = {
			-- 1. Định nghĩa Formatter cho từng loại file
			formatters_by_ft = {
				-- === LUA ===
				lua = { "stylua" },

				-- === JSON / YAML / MARKDOWN ===
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },

				-- === PYTHON ===
				-- Chạy tuần tự: Sắp xếp import (isort) -> Format code (black)
				python = { "isort", "black" },

				-- === C / C++ ===
				-- Dùng clang-format (Chuẩn mực của C/C++)
				c = { "clang-format" },
				cpp = { "clang-format" },

				-- === SHELL ===
				sh = { "shfmt" },

				-- === FLUTTER / DART ===
				-- Để trống để nó dùng LSP của Dart (cực ngon, không cần cài tool ngoài)
			},

			-- 2. Cấu hình Format khi lưu (Auto Save)
			-- Tớ đã bỏ comment để cậu dùng luôn, rất tiện.
			-- format_on_save = {
			--   timeout_ms = 500,        -- Thời gian chờ tối đa 0.5s
			--   lsp_format = "fallback", -- QUAN TRỌNG: Nếu không tìm thấy tool ở trên, sẽ nhờ LSP format hộ
			-- },
		},
	},
}
