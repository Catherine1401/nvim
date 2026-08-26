return {
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap", -- cần cho tính năng Dlv debug (GoDebug)
		},
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		build = ':lua require("go.install").update_all_sync()', -- tự cài/update gopls, gofumpt, goimports...

		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Tắt file-watcher động, đồng bộ cách làm với flutter_tools.lua và nvim_lspconfig.lua
			capabilities.workspace = capabilities.workspace or {}
			capabilities.workspace.didChangeWatchedFiles = {
				dynamicRegistration = false,
				relativePatternSupport = false,
			}

			require("go").setup({
				-- Giao gopls cho go.nvim tự setup qua nvim-lspconfig, dùng capabilities từ blink.cmp
        lsp_keymaps = false,
				lsp_cfg = {
					capabilities = capabilities,
					settings = {
						gopls = {
							gofumpt = true,
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = true,
							analyses = {
								unusedparams = true,
								shadow = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
						},
					},
				},
			})
		end,
	},
}
