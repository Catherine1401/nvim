return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",           -- Quản lý gói (Package Manager)
      "williamboman/mason-lspconfig.nvim", -- Cầu nối tự động
      "saghen/blink.cmp",                  -- Gợi ý code
      "b0o/schemastore.nvim",              -- Hỗ trợ JSON Schema
    },
    config = function()
      -- 1. LẤY CAPABILITIES TỪ BLINK (Để LSP biết Neovim hỗ trợ snippet, icon...)
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
        PATH = "prepend", -- Ưu tiên dùng tool của Mason
      })

      -- ======================================================================
      -- 3. SETUP MASON-LSPCONFIG (Cầu nối tự động)
      -- ======================================================================
      require("mason-lspconfig").setup({
        -- Danh sách server cần tự động cài đặt
        ensure_installed = {
          "lua_ls", -- Lua
          "jsonls", -- JSON
          "yamlls", -- YAML (Flutter dùng nhiều)
          "html",   -- HTML
          "cssls",  -- CSS
          "pyright"
          -- LƯU Ý: KHÔNG thêm 'dartls'. Plugin 'flutter-tools' sẽ tự lo.
        },

        -- TÍNH NĂNG MỚI CỦA NEOVIM 0.11+
        -- Tự động chạy vim.lsp.enable() cho các server đã cài qua Mason
        automatic_enable = true,
      })

      -- ======================================================================
      -- 4. CẤU HÌNH CHI TIẾT CHO TỪNG SERVER (SERVER SETTINGS)
      -- ======================================================================
      -- Mặc dù Mason-LSPConfig tự động bật server, ta vẫn cần dùng vim.lsp.config
      -- để áp dụng các cài đặt riêng (như sửa lỗi global 'vim' cho Lua).

      -- Cấu hình riêng cho Lua (Lua_ls)
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } }, -- Fix lỗi báo đỏ chữ 'vim'
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
          },
        },
      })

      -- Cấu hình riêng cho JSON (Jsonls)
      vim.lsp.config("jsonls", {
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- Cấu hình mặc định cho các server khác (để nhận capabilities của Blink)
      -- Chúng ta lặp qua danh sách server đã cài để áp dụng capabilities
      local installed_servers = require("mason-lspconfig").get_installed_servers()
      for _, server_name in ipairs(installed_servers) do
        if server_name ~= "lua_ls" and server_name ~= "jsonls" and server_name ~= "dartls" then
          vim.lsp.config(server_name, {
            capabilities = capabilities,
          })
        end
      end

      -- ======================================================================
      -- -- 5. TINH CHỈNH GIAO DIỆN (DIAGNOSTICS & UI)
      -- -- ======================================================================
      vim.diagnostic.config({
        virtual_text = false, -- Tắt dòng lỗi bên cạnh code (cho gọn)
        signs = true,         -- Hiện icon bên lề
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

      -- vim.diagnostic.config({
      --   signs = true,
      --   underline = true
      -- })

      local function toggle_visual_diagnostics()
        -- Lấy cấu hình hiện tại
        local current_config = vim.diagnostic.config()

        -- 🌟 SỬA LỖI: Kiểm tra xem virtual_text có phải là bảng (table) không 🌟
        -- Nếu là table, kiểm tra trường enabled hoặc prefix.
        -- Nếu là boolean, kiểm tra trực tiếp giá trị boolean đó.
        local is_enabled = false
        if type(current_config.virtual_text) == 'table' then
          -- Nếu là bảng, coi như đang bật nếu không bị disable rõ ràng
          is_enabled = current_config.virtual_text.enabled ~= false
        elseif type(current_config.virtual_text) == 'boolean' then
          -- Nếu là boolean, coi như đang bật nếu nó là true
          is_enabled = current_config.virtual_text == true
        end


        if is_enabled then
          -- TRẠNG THÁI LÀ BẬT -> TẮT VIRTUAL TEXT
          vim.diagnostic.config({
            virtual_text = false, -- Tắt bằng boolean
            -- signs = false,        -- Tắt signs
            -- underline = false,    -- Tắt underline
          })
        else
          -- TRẠNG THÁI LÀ TẮT -> BẬT VIRTUAL TEXT
          vim.diagnostic.config({
            -- Bật với đầy đủ cấu hình table (để không bị lỗi boolean lần sau)
            virtual_text = {
              enabled = true,
              prefix = '  ',
              severity = { min = vim.diagnostic.severity.HINT },
            },
            -- signs = true,         -- Bật signs
            -- underline = true,     -- Bật underline
          })
        end
      end


      vim.keymap.set('n', '<leader>dt', toggle_visual_diagnostics, { desc = 'Toggle Virtual Text Diagnostics' })

      -- -- ======================================================================
      -- -- 6. PHÍM TẮT LSP (KEYMAPS)
      -- -- ======================================================================
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          -- Các phím tắt chuẩn
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code Action" })
          vim.keymap.set("n", "<leader>ff", function()
            vim.lsp.buf.format({ async = true })
          end, { buffer = ev.buf, desc = "Format Code" })
        end,
      })
    end,
  },
}
