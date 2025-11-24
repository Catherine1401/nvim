return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false, -- Load ngay để tự động nhận diện dự án Flutter
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- Giúp menu chọn thiết bị đẹp hơn (UI Select)
      "mfussenegger/nvim-dap",  -- Hỗ trợ Debugger
    },
    config = function()
      -- Lấy capabilities từ blink.cmp để LSP hoạt động mượt mà
      local capabilities = require("blink.cmp").get_lsp_capabilities()

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
            device = true,      -- Hiện tên thiết bị đang chạy
          },
        },

        -- 3. Hướng dẫn Widget (Widget Guides) - Tính năng cực hay
        -- Vẽ đường kẻ nối Widget cha với con, giúp nhìn cây Widget dễ hơn
        widget_guides = {
          enabled = true,
        },

        -- 4. Closing Tags (Tự động hiện chú thích đóng ngoặc)
        -- VD: cuối dòng nó sẽ hiện ảo dòng chữ: /// Container
        closing_tags = {
          highlight = "Comment", -- Màu xám dịu mắt
          prefix = "/// ",       -- Ký tự phía trước
          enabled = true,
        },

        -- 5. Dev Tools & Log
        dev_log = {
          enabled = true,
          open_cmd = "tabedit", -- Mở log ở tab mới cho rộng
        },
        
        -- 6. Outline (Cấu trúc file)
        outline = {
          open_cmd = "30vnew", -- Mở bên phải, rộng 30
          auto_open = false,   -- Không tự mở, khi nào cần thì gọi
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
              }
            }
          end,
        },

        -- 8. Cấu hình LSP (Dart Analysis)
        lsp = {
          color = { -- Hiển thị màu sắc thật trong code (VD: Color(0xFFFF0000))
            enabled = true,
            background = true,
            virtual_text = true,
          },
          on_attach = function(client, bufnr)
            -- Có thể thêm keymap riêng cho LSP ở đây nếu cần
          end,
          capabilities = capabilities, -- Quan trọng: Kết nối với blink.cmp
          
          settings = {
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
      { "<leader>fs", function() require("telescope").extensions.flutter.commands() end, desc = "Flutter Commands" },
      -- Nhóm lệnh chạy App
      { "<leader>fr", "<cmd>FlutterRun<cr>", desc = "Chạy App (Run)" },
      { "<leader>fq", "<cmd>FlutterQuit<cr>", desc = "Tắt App (Quit)" },
      { "<leader>fR", "<cmd>FlutterRestart<cr>", desc = "Hot Restart (Toàn bộ)" },
      { "<leader>fh", "<cmd>FlutterReload<cr>", desc = "Hot Reload (Nhanh)" },
      -- Nhóm lệnh công cụ
      { "<leader>fd", "<cmd>FlutterDevices<cr>", desc = "Chọn thiết bị (Devices)" },
      { "<leader>fe", "<cmd>FlutterEmulators<cr>", desc = "Chọn máy ảo (Emulators)" },
      { "<leader>fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Bật/Tắt Outline" },
      { "<leader>fl", "<cmd>FlutterLogToggle<cr>", desc = "Bật/Tắt Log" },
      { "<leader>fc", "<cmd>FlutterCopyProfilerUrl<cr>", desc = "Copy Profiler URL" },
    },
  },
}
