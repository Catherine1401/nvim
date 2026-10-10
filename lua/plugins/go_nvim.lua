return {
	"ray-x/go.nvim",
	dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig" },
	ft = { "go", "gomod" },
	config = function()
		-- gopls do go.nvim dựng, dùng capabilities của blink.cmp và phím LSP sẵn có (nhóm UserLspConfig)
		require("go").setup({
			lsp_cfg = { capabilities = require("blink.cmp").get_lsp_capabilities() },
			lsp_keymaps = false,
			-- Binary goimports vừa format vừa sắp import; mặc định 'gopls' chỉ sắp import
			goimports = "goimports",
		})
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("GoFormat", {}),
			pattern = "*.go",
			callback = function()
				require("go.format").goimports()
			end,
		})
	end,
	keys = {
		{ "<leader>jt", "<cmd>GoTestFunc<cr>", ft = "go", desc = "Chạy test gần con trỏ" },
		{ "<leader>jf", "<cmd>GoTestFile<cr>", ft = "go", desc = "Chạy test của file" },
		{ "<leader>jp", "<cmd>GoTestPkg<cr>", ft = "go", desc = "Chạy test của package" },
	},
}
