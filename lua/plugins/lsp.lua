return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"saghen/blink.cmp",
			"b0o/schemastore.nvim",
			-- Thêm plugin màu Tailwind vào dependencies của LSP
			"roobert/tailwindcss-colorizer-cmp.nvim",
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- ======================================================================
			-- 2. SETUP MASON
			-- ======================================================================
			require("mason").setup({
				ui = {
					border = "rounded",
					width = 0.8,
					height = 0.8,
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
				PATH = "prepend",
			})

			-- ======================================================================
			-- 3. TỰ ĐỘNG CÀI ĐẶT TOÀN BỘ
			-- ======================================================================
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Core
					"lua_ls",
					"jsonls",
					"yamlls",

					-- === WEB DEV STACK (MỚI) ===
					"vtsls", -- Thay thế tsserver (Nhanh hơn, xịn hơn)
					"eslint", -- Linter bắt buộc cho Next.js
					"tailwindcss", -- Tailwind CSS
					"cssls",
					"html",

					-- Backend/Other
					"pyright",
					"marksman",
					"clangd",
					"jdtls",
					"rust_analyzer",

					-- Formatters & Linters
					"prettier", -- Formatter chuẩn cho JS/TS/React
					"markdownlint",
					"stylua",
					"shfmt",
					"eslint_d",
					"jsonlint",
					"emmet-language-server",
					"clang-format",
					"isort",
					"black",
					"google-java-format",
					"rustfmt",
				},
			})

			require("mason-lspconfig").setup({
				automatic_enable = true,
			})

			-- ======================================================================
			-- 5. CẤU HÌNH CHI TIẾT SERVER (Style 0.11)
			-- ======================================================================

			-- Lua
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
				},
			})

			-- === JS / TS / REACT / NEXTJS (VTSLS) ===
			-- vtsls ngon hơn tsserver ở khoản Auto Import và Rename File
			vim.lsp.config("vtsls", {
				capabilities = capabilities,
				settings = {
					complete_function_calls = true,
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
						experimental = {
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
					},
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							completeFunctionCalls = true,
						},
						inlayHints = {
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							variableTypes = { enabled = false },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = true },
						},
					},
				},
			})

			-- === TAILWIND CSS ===
			vim.lsp.config("tailwindcss", {
				capabilities = capabilities,
				settings = {
					tailwindCSS = {
						experimental = {
							classRegex = {
								{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
								{ "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
							},
						},
					},
				},
			})

			-- === EMMET ===
			vim.lsp.config("emmet_language_server", {
				capabilities = capabilities,
				filetypes = {
					"html",
					"css",
					"sass",
					"scss",
					"less",
					"javascriptreact",
					"typescriptreact",
					"vue",
					"svelte",
					"eruby",
					"pug",
				},
				init_options = {
					showExpandedAbbreviation = "always",
					showAbbreviationSuggestions = true,
					showSuggestionsAsSnippets = true,
					preferences = {
						["output.indent"] = "  ",
						["output.inlineBreak"] = 0,
					},
				},
				on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
			})
			vim.lsp.enable("emmet_language_server")

			-- JSON
			vim.lsp.config("jsonls", {
				capabilities = capabilities,
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			-- Các server khác (Mặc định)
			local installed_servers = require("mason-lspconfig").get_installed_servers()
			for _, server_name in ipairs(installed_servers) do
				if
					server_name ~= "lua_ls"
					and server_name ~= "jsonls"
					and server_name ~= "dartls"
					and server_name ~= "vtsls" -- Loại trừ vì đã config riêng
					and server_name ~= "tailwindcss" -- Loại trừ vì đã config riêng
				then
					vim.lsp.config(server_name, { capabilities = capabilities })
				end
			end

			-- ======================================================================
			-- 6. TINH CHỈNH GIAO DIỆN (DIAGNOSTICS)
			-- ======================================================================
			vim.diagnostic.config({
				virtual_text = false,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "▲",
						[vim.diagnostic.severity.HINT] = "⚑",
						[vim.diagnostic.severity.INFO] = "»",
					},
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})

			-- Hàm bật/tắt Virtual Text
			local function toggle_visual_diagnostics()
				local config = vim.diagnostic.config()
				local vt = config.virtual_text
				if vt == false then
					vim.diagnostic.config({ virtual_text = { prefix = "●" } })
					vim.notify("Virtual Text: ON", "info")
				else
					vim.diagnostic.config({ virtual_text = false })
					vim.notify("Virtual Text: OFF", "warn")
				end
			end

			vim.keymap.set("n", "<leader>dt", toggle_visual_diagnostics, { desc = "Toggle Diagnostics Text" })

			-- ======================================================================
			-- 7. PHÍM TẮT LSP (KEYMAPS)
			-- ======================================================================
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }
					-- (Giữ nguyên các keymap cũ của cậu)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
					vim.keymap.set(
						"n",
						"gi",
						vim.lsp.buf.implementation,
						{ buffer = ev.buf, desc = "Go to implementation" }
					)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover Info" })
					vim.keymap.set(
						"n",
						"<C-k>",
						vim.lsp.buf.signature_help,
						{ buffer = ev.buf, desc = "Signature Help" }
					)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Symbol" })
					vim.keymap.set(
						{ "n", "v" },
						"<leader>ca",
						vim.lsp.buf.code_action,
						{ buffer = ev.buf, desc = "Code Action" }
					)
				end,
			})
		end,
	},
}
