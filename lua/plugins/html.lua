return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" }, -- Load khi chuẩn bị lưu file
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Phím tắt Format thủ công
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "Format Code",
			},
		},
		opts = {
			-- 1. Định nghĩa Formatter cho từng loại file
			formatters_by_ft = {
				lua = { "stylua" },

				-- Web Stack (Dùng Prettier cho tất cả)
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },

				-- Shell Script
				sh = { "shfmt" },

				-- Flutter/Dart: Để trống!
				-- Conform sẽ không tìm thấy formatter nào ở đây,
				-- và nó sẽ tự động dùng LSP (Dart Analysis) nhờ tính năng lsp_format = "fallback"
			},

			-- 2. Cấu hình Format khi lưu (Auto Save)
			-- format_on_save = {
			--   timeout_ms = 500,        -- Thời gian chờ tối đa 0.5s (để không bị lag máy)
			--   lsp_format = "fallback", -- QUAN TRỌNG: Nếu không có tool format riêng, hãy dùng LSP
			-- },
		},
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			-- 1. Gán Linter cho từng loại file
			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				markdown = { "markdownlint" },
				json = { "jsonlint" },
				-- Flutter/Dart không cần linter riêng vì LSP của nó đã quá xịn rồi
			}

			-- 2. Tự động chạy Lint (Autocmd)
			-- Chạy khi: Mở file, Lưu file, hoặc Thoát chế độ Insert
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					-- Chỉ chạy linter nếu file đó có linter được cấu hình
					-- try_lint() tự động tìm trong linters_by_ft
					lint.try_lint()
				end,
			})
		end,
	},
}
