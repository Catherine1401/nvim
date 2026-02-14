return {
	{
		"Exafunction/windsurf.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		event = "BufReadPre",
		config = function()
			require("codeium").setup({
				enable_chat = true,
				enable_cmp_source = false,
				virtual_text = {
					enabled = true,
					virtual_text_priority = 65535,
					default_filetype_enabled = true,
					filetypes = {
						TelescopePrompt = false,
						["neo-tree"] = false,
						["dap-repl"] = false,
					},
					map_keys = true,
					key_bindings = {
						accept = "<M-k>",
						accept_word = "<M-w>",
						accept_line = "<M-l>",
						clear = "<M-c>",
						next = "<M-]>",
						prev = "<M-[>",
					},
				},
				workspace_root = {
					use_lsp = true,
					paths = { ".git", "Cargo.toml", "pubspec.yaml", "package.json", "composer.json" },
				},
			})
		end,

		-- === CẤU HÌNH PHÍM TẮT TẠI ĐÂY ===
		keys = {
			-- Phím tắt Bật/Tắt AI (Toggle)
			{
				"<leader>at",
				"<cmd>Codeium Toggle<cr>",
				desc = "AI: Bật/Tắt Gợi ý (Toggle)",
			},

			-- Tớ cũng thêm luôn phím mở Chat nhanh (nếu cậu thích dùng trình duyệt)
			{
				"<leader>ac",
				"<cmd>Codeium Chat<cr>",
				desc = "AI: Chat (Browser)",
			},
		},
	},
}
