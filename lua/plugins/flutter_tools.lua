return {
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false, -- Load ngay để tự động nhận diện dự án Flutter
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- Giúp menu chọn thiết bị đẹp hơn (UI Select)
			"mfussenegger/nvim-dap", -- Hỗ trợ Debugger
		},
		config = function()
			-- Lấy capabilities từ blink.cmp để LSP hoạt động mượt mà
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Tắt file-watcher động của LSP (xem lua/plugins/lsp.lua)
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
				-- Tắt mặc định để không tạo buffer log phình to theo thời gian.
				-- Cần xem log thì bấm <leader>fl (FlutterLogToggle).
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
							},
						}
					end,
				},

				-- 8. Cấu hình LSP (Dart Analysis)
				lsp = {
					capabilities = capabilities, -- Quan trọng: Kết nối với blink.cmp

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

			-- Tích hợp với Telescope (nếu cậu dùng Telescope)
			require("telescope").load_extension("flutter")
		end,

		-- 9. Phím tắt chuyên dụng (Keymaps)
		keys = {
			{
				"<leader>fs",
				function()
					require("telescope").extensions.flutter.commands()
				end,
				desc = "Flutter Commands",
			},
			-- Nhóm lệnh chạy App
			{ "<leader>fr", "<cmd>FlutterRun<cr>", desc = "Chạy App (Run)" },
			{ "<leader>fg", "<cmd>FlutterDebug<cr>", desc = "Chạy App (Force Debug)" },
			{ "<leader>fq", "<cmd>FlutterQuit<cr>", desc = "Tắt App (Quit)" },
			{ "<leader>fR", "<cmd>FlutterRestart<cr>", desc = "Hot Restart (Toàn bộ)" },
			{ "<leader>fh", "<cmd>FlutterReload<cr>", desc = "Hot Reload (Nhanh)" },
			{ "<leader>fa", "<cmd>FlutterAttach<cr>", desc = "Attach vào App đang chạy" },
			{ "<leader>fx", "<cmd>FlutterDetach<cr>", desc = "Detach (giữ app chạy trên máy)" },

			-- Nhóm lệnh công cụ
			{ "<leader>fd", "<cmd>FlutterDevices<cr>", desc = "Chọn thiết bị (Devices)" },
			{ "<leader>fe", "<cmd>FlutterEmulators<cr>", desc = "Chọn máy ảo (Emulators)" },
			{ "<leader>fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Bật/Tắt Outline" },
			{ "<leader>fu", "<cmd>FlutterOutlineOpen<cr>", desc = "Mở Outline" },
			{ "<leader>fl", "<cmd>FlutterLogToggle<cr>", desc = "Bật/Tắt Log" },
			{ "<leader>fz", "<cmd>FlutterLogClear<cr>", desc = "Xóa Log" },
			{ "<leader>fc", "<cmd>FlutterCopyProfilerUrl<cr>", desc = "Copy Profiler URL" },

			-- Nhóm Debug/DevTools
			{ "<leader>fv", "<cmd>FlutterVisualDebug<cr>", desc = "Bật/Tắt Visual Debug" },
			{ "<leader>fi", "<cmd>FlutterInspectWidget<cr>", desc = "Bật/Tắt Inspect Widget" },
			{ "<leader>fD", "<cmd>FlutterDevTools<cr>", desc = "Khởi động DevTools Server" },
			{ "<leader>fO", "<cmd>FlutterOpenDevTools<cr>", desc = "Mở trang DevTools" },

			-- Nhóm LSP & Dart
			{ "<leader>fp", "<cmd>FlutterPubGet<cr>", desc = "Chạy pub get" },
			{ "<leader>fj", "<cmd>FlutterReanalyze<cr>", desc = "Buộc LSP phân tích lại" },
			{ "<leader>fL", "<cmd>FlutterLspRestart<cr>", desc = "Khởi động lại Dart LSP" },
			{ "<leader>fm", "<cmd>FlutterRename<cr>", desc = "Đổi tên symbol (rename)" },
		},
	},
}
