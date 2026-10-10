-- Project Flutter (có pubspec.yaml ở cwd): nạp ngay sau màn hình đầu để :Flutter* sẵn sàng; nơi khác chỉ nạp khi mở file dart hoặc bấm phím r
local IN_FLUTTER_PROJECT = vim.uv.fs_stat(vim.fn.getcwd() .. "/pubspec.yaml") ~= nil

return {
	{
		"nvim-flutter/flutter-tools.nvim",
		ft = "dart",
		event = IN_FLUTTER_PROJECT and "VeryLazy" or nil,
		-- Thay client VM service của plugin bằng bản tự kết nối lại; phải chạy trước khi plugin require module này
		init = function() package.loaded["flutter-tools.vm_service"] = require("config.flutter.vm_service") end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- Giúp menu chọn thiết bị đẹp hơn (UI Select)
			"mfussenegger/nvim-dap", -- Hỗ trợ Debugger
		},
		config = function()
			-- Lấy capabilities từ blink.cmp để LSP hoạt động mượt mà
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Tắt file-watcher động của LSP (xem lua/plugins/nvim_lspconfig.lua)
			-- Repo Flutter lớn có .dart_tool/ và build/ với hàng chục nghìn file
			capabilities.workspace = capabilities.workspace or {}
			capabilities.workspace.didChangeWatchedFiles = {
				dynamicRegistration = false,
				relativePatternSupport = false,
			}

			-- Thư mục dartls không cần phân tích: giảm mạnh số file phải index khi
			-- mở project lớn. Go-to-definition vào SDK/package vẫn hoạt động.
			-- Đường dẫn Flutter SDK suy ra từ lệnh flutter trong PATH, không hardcode.
			local excluded_folders = { vim.fn.expand("$HOME/.pub-cache") }
			local flutter_bin = vim.fn.exepath("flutter")
			if flutter_bin ~= "" then
				-- <sdk>/bin/flutter -> <sdk>
				excluded_folders[#excluded_folders + 1] = vim.fs.dirname(vim.fs.dirname(flutter_bin))
			end

			require("flutter-tools").setup({
				-- 1. Giao diện (UI)
				ui = {
					border = "rounded", -- Viền bo tròn hiện đại
					notification_style = "plugin", -- Dùng nvim-notify (nếu có)
				},

				-- 2. Trang trí (Decorations)
				decorations = {
					statusline = {
						app_version = true, -- Hiện version app trên statusline
						device = true, -- Hiện tên thiết bị đang chạy
					},
				},

				-- 3. Hướng dẫn Widget (Widget Guides)
				-- Vẽ đường kẻ nối Widget cha với con dựa trên notification flutter/outline
				-- của dartls, tính lại mỗi lần buffer đổi -> rất nặng trên project lớn.
				-- Tắt để tránh đơ khi mở/sửa file Dart.
				widget_guides = {
					enabled = false,
				},

				-- 4. Closing Tags (Tự động hiện chú thích đóng ngoặc)
				-- VD: cuối dòng nó sẽ hiện ảo dòng chữ: /// Container
				closing_tags = {
					highlight = "Comment", -- Màu xám dịu mắt
					prefix = "/// ", -- Ký tự phía trước
					enabled = true,
				},

				-- 5. Dev Tools & Log
				-- Bật để thu log app; mở/tắt bằng <leader>rl, xóa bằng <leader>rz.
				dev_log = {
					enabled = true,
					notify_errors = true, -- sửa lỗi chính tả: nofify_errors -> notify_errors
					open_cmd = "tabedit", -- Mở log ở tab mới cho rộng
				},

				-- 6. Outline (Cấu trúc file)
				outline = {
					-- open_cmd = "30vnew", -- Mở bên phải, rộng 30
					auto_open = false, -- Không tự mở, khi nào cần thì gọi
				},

				-- 7. Debugger (DAP)
				debugger = {
					enabled = true,
					run_via_dap = true, -- Chạy app qua DAP để có thể đặt breakpoint
					exception_breakpoints = {},
					register_configurations = function(paths)
						require("dap").configurations.dart = {
							-- Cấu hình mặc định cho Debugger
							{
								type = "dart",
								request = "launch",
								name = "Launch Flutter",
								dartSdkPath = paths.dart_sdk,
								flutterSdkPath = paths.flutter_sdk,
								program = "${workspaceFolder}/lib/main.dart",
								cwd = "${workspaceFolder}",
								-- Chỉ dừng và step trong code của project: mặc định adapter bật debug cả SDK lẫn package ngoài nên step đi vào framework.dart
								debugSdkLibraries = false,
								debugExternalPackageLibraries = false,
							},
						}
					end,
				},

				-- 8. Cấu hình LSP (Dart Analysis)
				lsp = {
					capabilities = capabilities, -- Quan trọng: Kết nối với blink.cmp

					-- Chỉ nhận diagnostics của file đang mở, tránh dartls đẩy cả project vào nvim
					handlers = { ["textDocument/publishDiagnostics"] = require("config.diag_filter") },

					settings = {
						analysisExcludedFolders = excluded_folders,
						showTodos = true,
						completeFunctionCalls = true,
						renameFilesWithClasses = "prompt", -- Hỏi khi đổi tên file class
						enableSnippets = true,
						updateImportsOnRename = true, -- Tự động sửa import khi đổi tên file
					},
				},
			})

			-- Plugin chỉ đăng ký lệnh Flutter* khi mở file dart/pubspec; cwd là project Flutter thì kích hoạt ngay
			if vim.uv.fs_stat(vim.fn.getcwd() .. "/pubspec.yaml") then
				vim.api.nvim_exec_autocmds("BufEnter", { group = "FlutterToolsGroup", pattern = "pubspec.yaml" })
			end

			-- Giữ chế độ chọn widget qua hot restart và tự cuộn log xuống cuối
			require("config.flutter.inspect").setup()
			require("config.flutter.log_follow").setup()
			require("config.flutter.tree").setup()
			require("config.flutter.debug_app").setup()

			-- Telescope đã nạp thì nạp luôn extension; chưa thì nạp ở lần bấm phím rs đầu tiên
			if package.loaded["telescope"] then
				require("telescope").load_extension("flutter")
			end
		end,

		-- 9. Phím tắt chuyên dụng (Keymaps)
		keys = {
			{
				"<leader>rs",
				function()
					require("telescope").load_extension("flutter")
					require("telescope").extensions.flutter.commands()
				end,
				desc = "Flutter Commands",
			},
			-- Nhóm lệnh chạy App
			{ "<leader>rr", "<cmd>FlutterRun<cr>", desc = "Chạy App (Run)" },
			{ "<leader>rq", "<cmd>FlutterQuit<cr>", desc = "Tắt App (Quit)" },
			{ "<leader>rt", "<cmd>FlutterRestart<cr>", desc = "Hot Restart (Toàn bộ)" },
			{ "<leader>rh", "<cmd>FlutterReload<cr>", desc = "Hot Reload (Nhanh)" },

			-- Nhóm lệnh công cụ
			{ "<leader>rd", "<cmd>FlutterDevices<cr>", desc = "Chọn thiết bị (Devices)" },
			{ "<leader>re", "<cmd>FlutterEmulators<cr>", desc = "Chọn máy ảo (Emulators)" },
			{ "<leader>ro", "<cmd>FlutterOutlineToggle<cr>", desc = "Bật/Tắt Outline" },
			{ "<leader>rl", "<cmd>FlutterLogToggle<cr>", desc = "Bật/Tắt Log" },
			{ "<leader>rz", "<cmd>FlutterLogClear<cr>", desc = "Xóa Log" },

			-- Nhóm Debug/DevTools
			{ "<leader>ri", function() require("config.flutter.inspect").toggle() end, desc = "Bật/Tắt Inspect Widget" },
			{ "<leader>rw", "<cmd>FlutterOpenDevTools<cr>", desc = "Mở trang DevTools" },
			{ "<leader>rg", function() require("config.flutter.tree").toggle() end, desc = "Bật/Tắt cây widget toàn app" },

			-- Nhóm LSP & Dart
			{ "<leader>rp", "<cmd>FlutterPubGet<cr>", desc = "Chạy pub get" },
			{ "<leader>rm", "<cmd>FlutterRename<cr>", desc = "Đổi tên symbol (rename)" },
		},
	},
}
