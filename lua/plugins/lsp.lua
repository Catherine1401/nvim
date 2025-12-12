return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim", -- Quản lý gói
			"williamboman/mason-lspconfig.nvim", -- Cầu nối LSP
			"WhoIsSethDaniel/mason-tool-installer.nvim", -- Cầu nối Tool (Format/Lint) - QUAN TRỌNG
			"saghen/blink.cmp", -- Gợi ý code
			"b0o/schemastore.nvim", -- Hỗ trợ JSON Schema
		},
		config = function()
			-- 1. Lấy capabilities từ Blink
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- ======================================================================
			-- 2. SETUP MASON (Trình quản lý gói)
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
			-- 3. TỰ ĐỘNG CÀI ĐẶT TOÀN BỘ (LSP + TOOL)
			-- ======================================================================
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- LSP Servers
					"lua_ls",
					"jsonls",
					"yamlls",
					"html",
					"cssls",
					"pyright",
					"marksman",
					"clangd",
					"jdtls",
					"rust_analyzer",

					-- Formatters & Linters (Không phải LSP)
					"prettier", -- Formatter đa năng
					"markdownlint", -- Linter check lỗi markdown
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

			-- ======================================================================
			-- 4. SETUP MASON-LSPCONFIG (Tự động bật LSP)
			-- ======================================================================
			require("mason-lspconfig").setup({
				-- Không cần ensure_installed ở đây nữa vì mason-tool-installer lo rồi
				automatic_enable = true,
			})

			-- ======================================================================
			-- 5. CẤU HÌNH CHI TIẾT SERVER (Dùng vim.lsp.config)
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

			-- === CẤU HÌNH RIÊNG CHO EMMET ===
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

				-- THÊM ĐOẠN NÀY: Ép Emmet dùng 2 spaces
				init_options = {
					showExpandedAbbreviation = "always",
					showAbbreviationSuggestions = true,
					showSuggestionsAsSnippets = true,
					-- Đây là chìa khóa:
					preferences = {
						["output.indent"] = "  ", -- Bắt buộc dùng 2 dấu cách
						["output.inlineBreak"] = 0,
					},
				},

				-- Giữ nguyên đoạn này để tắt format của Emmet (nhường cho Prettier)
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
				if server_name ~= "lua_ls" and server_name ~= "jsonls" and server_name ~= "dartls" then
					vim.lsp.config(server_name, { capabilities = capabilities })
				end
			end

			-- ======================================================================
			-- 6. TINH CHỈNH GIAO DIỆN (DIAGNOSTICS)
			-- ======================================================================
			vim.diagnostic.config({
				virtual_text = false, -- Mặc định tắt cho gọn
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

			-- Hàm bật/tắt Virtual Text thông minh
			local function toggle_visual_diagnostics()
				local config = vim.diagnostic.config()
				local vt = config.virtual_text
				-- Logic kiểm tra đơn giản hơn: Nếu đang tắt hoặc false -> Bật lên
				if vt == false then
					vim.diagnostic.config({ virtual_text = { prefix = "●" } }) -- Bật
					vim.notify("Virtual Text: ON", "info")
				else
					vim.diagnostic.config({ virtual_text = false }) -- Tắt
					vim.notify("Virtual Text: OFF", "warn")
				end
			end

			-- Phím tắt Toggle Diagnostic
			vim.keymap.set("n", "<leader>dt", toggle_visual_diagnostics, { desc = "Toggle Diagnostics Text" })

			-- ======================================================================
			-- 7. PHÍM TẮT LSP (KEYMAPS)
			-- ======================================================================
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }

					-- Định nghĩa (Go to)
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
					vim.keymap.set(
						"n",
						"gi",
						vim.lsp.buf.implementation,
						{ buffer = ev.buf, desc = "Go to implementation" }
					)

					-- Thông tin (Info)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover Info" })
					vim.keymap.set(
						"n",
						"<C-k>",
						vim.lsp.buf.signature_help,
						{ buffer = ev.buf, desc = "Signature Help" }
					)

					-- Thao tác (Action)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename Symbol" })
					vim.keymap.set(
						{ "n", "v" },
						"<leader>ca",
						vim.lsp.buf.code_action,
						{ buffer = ev.buf, desc = "Code Action" }
					)

					-- Format (Đổi từ <leader>ff sang <leader>cf cho đúng chuẩn Code Format)
					-- Vì <leader>ff thường dùng cho Find Files
					-- vim.keymap.set("n", "<leader>cf", function()
					-- 	vim.lsp.buf.format({ async = true })
					-- end, { buffer = ev.buf, desc = "Format Code" })
				end,
			})
		end,
	},
}
