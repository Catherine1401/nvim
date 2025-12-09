return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" }, -- Load khi chuẩn bị lưu file
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Phím tắt Format thủ công
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "Format Code",
      },
    },
    opts = {
      -- 1. Định nghĩa Formatter cho từng loại file
      formatters_by_ft = {
        -- === LUA ===
        lua = { "stylua" },

        -- === WEB STACK (HTML, CSS, JS, TS...) ===
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },

        -- === PYTHON ===
        -- Chạy tuần tự: Sắp xếp import (isort) -> Format code (black)
        python = { "isort", "black" },

        -- === C / C++ ===
        -- Dùng clang-format (Chuẩn mực của C/C++)
        c = { "clang-format" },
        cpp = { "clang-format" },

        -- === JAVA ===
        -- Dùng google-java-format (Chuẩn của Google, rất phổ biến)
        java = { "google-java-format" },

        -- === RUST ===
        -- Rustfmt là chân ái. Thêm lsp_format = "fallback" để dự phòng.
        rust = { "rustfmt", lsp_format = "fallback" },

        -- === SHELL ===
        sh = { "shfmt" },

        -- === FLUTTER / DART ===
        -- Để trống để nó dùng LSP của Dart (cực ngon, không cần cài tool ngoài)
      },

      -- 2. Cấu hình Format khi lưu (Auto Save)
      -- Tớ đã bỏ comment để cậu dùng luôn, rất tiện.
      -- format_on_save = {
      --   timeout_ms = 500,        -- Thời gian chờ tối đa 0.5s
      --   lsp_format = "fallback", -- QUAN TRỌNG: Nếu không tìm thấy tool ở trên, sẽ nhờ LSP format hộ
      -- },
    },
  },
}
