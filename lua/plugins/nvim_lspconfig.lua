return {
	{
		"neovim/nvim-lspconfig",
		-- File mở lúc khởi động: nạp LSP sau màn hình đầu (VeryLazy); file mở sau đó: nạp ở BufReadPre/BufNewFile như cũ
		event = "User LspStart",
		init = function()
			local group = vim.api.nvim_create_augroup("LspDeferredStart", {})
			local function start()
				vim.api.nvim_exec_autocmds("User", { pattern = "LspStart" })
			end
			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "VeryLazy",
				once = true,
				callback = function()
					if vim.api.nvim_buf_get_name(0) ~= "" then
						start()
						-- mason-tool-installer vốn tự chạy ở VimEnter; LSP nạp sau VimEnter nên gọi tay để giữ việc kiểm tra cài công cụ như cũ
						pcall(vim.api.nvim_del_augroup_by_name, "mti_start")
						require("mason-tool-installer").run_on_start()
					end
					vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, { group = group, once = true, callback = start })
				end,
			})
		end,
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"saghen/blink.cmp",
			"b0o/schemastore.nvim",
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Tắt file-watcher động của LSP.
			-- Trên repo lớn, server đăng ký watcher cho hàng chục nghìn file
			-- (.dart_tool/, build/, node_modules/...) khiến UI đơ khi mở project.
			capabilities.workspace = capabilities.workspace or {}
			capabilities.workspace.didChangeWatchedFiles = {
				dynamicRegistration = false,
				relativePatternSupport = false,
			}

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

					-- Backend/Other
					"pyright",
					"marksman",
					"clangd",

					-- Formatters & Linters
					"prettier", -- Formatter cho JSON/YAML/Markdown
					"markdownlint",
					"stylua",
					"shfmt",
					"jsonlint",
					"clang-format",
					"isort",
					"black",
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

			-- JSON
			vim.lsp.config("jsonls", {
				capabilities = capabilities,
				settings = {
					json = {
						validate = { enable = true },
					},
				},
				-- Chỉ tạo danh sách schema (tốn vài ms) khi server JSON thật sự khởi động
				before_init = function(_, config)
					config.settings.json.schemas = require("schemastore").json.schemas()
				end,
			})

			-- Các server khác (Mặc định)
			local installed_servers = require("mason-lspconfig").get_installed_servers()
			for _, server_name in ipairs(installed_servers) do
				if
					server_name ~= "lua_ls"
					and server_name ~= "jsonls"
					-- and server_name ~= "dartls"
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
				end,
			})
		end,
	},
}
