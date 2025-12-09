return {
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
